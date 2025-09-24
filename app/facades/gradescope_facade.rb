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

      assignments = props['table_data'] || []
      assignments.map { |data| Lmss::Gradescope::Assignment.new(data) }
    rescue Lmss::Gradescope::AuthenticationError => e
      Rails.logger.error "Authentication failed: #{e.message}"
      raise e
    rescue => e
      Rails.logger.error "Failed to fetch Gradescope assignments: #{e.message}"
      []
    end
  end

  ##
  # Provisions a new extension to a user.
  #
  # @param   [Integer] courseId the course to provision the extension in.
  # @param   [Array<Integer>] studentIds the students to provision the extension for.
  # @param   [Integer] assignmentId the assignment the extension should be provisioned for.
  # @param   [String]  newDueDate the date the assignment should be due.
  # @return  [Faraday::Response] the override that acts as the extension.
  # @raises  [FailedPipelineError] if the creation response body could not be parsed.
  # @raises  [NotFoundError]       if the user has an existing override that cannot be located.
  def provision_extension(courseId, studentIds, assignmentId, newDueDate)
    raise NotImplementedError, 'SOON!'
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
