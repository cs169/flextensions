class GradescopeFacade < ExtensionFacadeBase
  class GradescopeAPIError < StandardError; end

  GRADESCOPE_URL = ENV.fetch('GRADESCOPE_URL', nil)

  def initialize(token)
    @api_token = token
    @gradescope_conn = Lmss::Gradescope::Client.new
  end

  # The Gradescope API Client does not operate with user tokens.
  # Instead, it uses a service account.
  # We maintain this method for compatibility with other facade instances.
  def self.from_user(_user = nil)
    new
  end
end
