class GradescopeFacade < LmsFacade
  class GradescopeAPIError < StandardError; end

  GRADESCOPE_URL = ENV.fetch('GRADESCOPE_URL', 'https://www.gradescope.com')

  def initialize(_token = nil)
    @api_token = nil # Gradescope does not support API tokens.
    @gradescope_conn = nil  # Wait until authenticated
  end

  # The Gradescope API Client does not operate with user tokens.
  # Instead, it uses a service account.
  # We maintain this method for compatibility with other facade instances.
  def self.from_user(_user = nil)
    new
  end

  ### Review the Canvas Facade for methods which might need to be implemented here.
  # Add those methods to the base facade as well.

  ##
  # Gets all Gradescope assignments for a course.
  #
  # @param  [String] course_id the Gradescope course id to fetch assignments for.
  # @return [Array<Lmss::Gradescope::Assignment>] list of assignments in the course.
  def get_all_assignments(course_id)
    ensure_authenticated!
    begin
      # Get HTML content from Gradescope
      html = @gradescope_conn.get("/courses/#{course_id}/assignments")
      if html.blank?
        Rails.logger.error 'Failed to fetch assignments: No response'
        return []
      end

      # Extract React props containing assignment data from HTML
      props = @gradescope_conn.extract_react_props(html, 'AssignmentsTable')
      return [] unless props

      assignment_data = props['table_data'] || []
      assignment_data.map { |data| Lmss::Gradescope::Assignment.new(data) }
    rescue Lmss::Gradescope::AuthenticationError => e
      Rails.logger.error "Authentication failed: #{e.message}"
      raise e
    rescue => e
      Rails.logger.error "Failed to fetch Gradescope assignments: #{e.message}"
      []
    end
  end

  ##
  # Gets a list of the assignment overrides for a specified assignment.
  #
  # @param   [String]    courseId     the course to fetch the overrides from.
  # @param   [String]    assignmentId the assignment to fetch the overrides from.
  # @return  [Array<Lmss::Gradescope::Override>] all of the overrides for the specified assignment.
  def get_assignment_overrides(course_id, assignment_id)
    ensure_authenticated!
    begin
      html = @gradescope_conn.get("/courses/#{course_id}/assignments/#{assignment_id}/extensions")
      if html.blank?
        Rails.logger.error 'Failed to fetch assignment extensions: No response'
        return []
      end

      # Extract React props containing overrides data from HTML
      overrides_data = @gradescope_conn.extract_all_react_props(html, 'EditExtension')
      return [] unless overrides_data

      overrides_data.map { |data| Lmss::Gradescope::Override.new(data) }
    rescue => e
      Rails.logger.error "Failed to fetch assignment extensions: #{e.message}"
      []
    end
  end

  def get_existing_student_override(course_id, assignment_id, student_id)
    ensure_authenticated!
    overrides = get_assignment_overrides(course_id, assignment_id)
    overrides.find { |override| override.student_id == student_id }
  end

  ##
  # Provisions a new extension to a user.
  #
  # @param   [String] courseId the course to provision the extension in.
  # @param   [String] email of student to provision the extension for.
  # @param   [String] assignmentId the assignment the extension should be provisioned for.
  # @param   [String] newDueDate the date the assignment should be due.
  # @return  [Lmss::Gradescope::BaseExtension] the extension that was provisioned.
  def provision_extension(course_id, student_email, assignment_id, new_due_date)
    ensure_authenticated!
    begin
      # get extension page
      html = @gradescope_conn.get("/courses/#{course_id}/assignments/#{assignment_id}/extensions")
      if html.blank?
        Rails.logger.error 'Failed to fetch assignment extensions: No response'
        return nil
      end

      # Extract React props containing students data from HTML
      students_data = @gradescope_conn.extract_react_props(html, 'AddExtension')
      return nil unless students_data

      student_data = students_data['students'].find { |s| s['email'] == student_email }
      unless student_data
        Rails.logger.error "Failed to fetch assignment extensions: Student #{student_email} not found"
        return nil
      end
      student_id = student_data['id']

      # Build request payload
      request_payload = {
        'override' => {
          'user_id' => student_id,
          'settings' => {},
          'visible' => true
        }
      }

      if new_due_date
        request_payload['override']['settings']['due_date'] = {
          'type' => 'absolute',
          'value' => new_due_date
        }
        request_payload['override']['settings']['hard_due_date'] = {
          'type' => 'absolute',
          'value' => new_due_date
        }
      end

      @gradescope_conn.post(
        "/courses/#{course_id}/assignments/#{assignment_id}/extensions", request_payload)

      # get id of created extension
      override = get_existing_student_override(course_id, assignment_id, student_id)
      unless override
        Rails.logger.error "Failed to verify extension creation for student #{student_email}"
        return nil
      end
      override
    rescue => e
      Rails.logger.error "Failed to provision extension: #{e.message}"
      raise e
    end
  end

  private

  # Performs authentication to Gradescope if not already authenticated.
  def ensure_authenticated!
    return if @gradescope_conn

    @gradescope_conn = Lmss::Gradescope::Client.new(
      ENV.fetch('GRADESCOPE_EMAIL'),
      ENV.fetch('GRADESCOPE_PASSWORD'),
    )
    raise GradescopeAPIError, 'Failed to authenticate to Gradescope' unless @gradescope_conn
  end
end
