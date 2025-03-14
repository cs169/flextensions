##
# Base class for a validation error.
class ValidationError < StandardError
  ##
  # Constructor for error.
  #
  # @param message the error message (defaults to "Validation Error").
  def initialize(message = 'Validation Error')
    super
  end
end
