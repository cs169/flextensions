class GradescopeFacade < LmsFacade
  class GradescopeAPIError < StandardError; end

  GRADESCOPE_URL = ENV.fetch('GRADESCOPE_URL', 'https://www.gradescope.com')

  def initialize(_token)
    @api_token = nil # Gradescope does not support API tokens.
    @gradescope_conn = Lmss::Gradescope::Client.new
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
end
