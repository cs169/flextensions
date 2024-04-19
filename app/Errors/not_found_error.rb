##
# Base error for when values cannot be found.
class NotFoundError < StandardError
  ##
  # Constructor for the error.
  #
  # @param [String] message the error message (defaults to "Not Found Error").
  def initialize(message="Not Found Error")
    super(message)
  end
end
