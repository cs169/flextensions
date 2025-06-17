module Lmss
  module Gradescope
    class Error < StandardError; end
    class AuthenticationError < Error; end
    class NotFoundError < Error; end
    class RequestError < Error; end
  end
end
