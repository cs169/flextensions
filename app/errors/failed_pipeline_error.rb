##
# Base error for a pipeline failure.
class FailedPipelineError < StandardError
  ##
  # Constructor for error.
  #
  # @param [String] pipeline the pipeline that failed.
  # @param [String] errorStage the stage in the pipeline the failure occured at.
  # @param [String] additionalMessage any additional info for the error (defaults to "")
  def initialize(pipeline, errorStage, additionalMessage = '')
    message = "An error occured with #{pipeline} at #{errorStage}"
    message += ": #{additionalMessage}" if additionalMessage.length >= 0
    super(message)
  end
end
