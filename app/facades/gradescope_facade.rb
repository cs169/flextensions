class GradescopeFacade < LmsFacade
  class GradescopeAPIError < StandardError; end

  GRADESCOPE_URL = ENV.fetch('GRADESCOPE_URL', 'https://www.gradescope.com')

  def initialize(_token)
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

  # Fetch all Gradescope assignments for a given course.
  def get_all_assignments(course_id)
    ensure_authenticated!
    html = @client.get("/courses/#{@course_id}/assignments")
    if !response
      Rails.logger.error "Failed to fetch assignments: No response"
      return []
    elsif response.status == 401 || response.status == 403
      raise Lmss::Gradescope::AuthenticationError, "Unauthorized access: #{response&.body}"
    elsif !response&.success?
      Rails.logger.error "Failed to fetch assignments: #{response&.body}"
      return []
    end

    props = @client.extract_react_props(html, 'AssignmentsTable')

    return [] unless props

    assignments = props['table_data'] || []
    assignments.map { |data| Lmss::Gradescope::Assignment.new(data) }
    assignments

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

  def ensure_authenticated!
    return if @gradescope_conn

    @gradescope_conn = Lmss::Gradescope.login(
      ENV.fetch('GRADESCOPE_EMAIL'),
      ENV.fetch('GRADESCOPE_PASSWORD')
    )
    raise GradescopeAPIError, 'Failed to authenticate to Gradescope' unless @gradescope_conn
  end

end
