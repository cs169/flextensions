# Calculates the dates to be set on an external LMS when provisioning an extension.
#
# This service encapsulates the logic for determining:
# - release_date: When the assignment becomes available (currently always nil)
# - due_date: The new due date from the approved extension request
# - late_due_date: The deadline for late submissions, calculated based on course settings
#
# The late_due_date logic:
# - If the assignment has no late_due_date, returns nil (no late due date should be set)
# - If extend_late_due_date setting is true (default), shifts the late due date by the same
#   delta as the extension (preserving the gap between due date and late due date)
# - If extend_late_due_date setting is false, returns the later of the original late due date
#   and the new extended due date
class AssignmentDateCalculator
  attr_reader :assignment, :request, :course_settings

  # @param assignment [Assignment] The assignment being extended
  # @param request [Request] The extension request with the new requested_due_date
  # @param course_settings [CourseSettings, nil] The course settings (may be nil)
  def initialize(assignment:, request:, course_settings:)
    @assignment = assignment
    @request = request
    @course_settings = course_settings
  end

  # Returns the calculated dates for the extension
  # @return [Hash] with keys :release_date, :due_date, :late_due_date
  def calculate
    {
      release_date: release_date,
      due_date: due_date,
      late_due_date: late_due_date
    }
  end

  # The release date for the assignment (currently always nil)
  # @return [nil]
  def release_date
    nil
  end

  # The new due date from the extension request
  # @return [DateTime]
  def due_date
    request.requested_due_date
  end

  # Calculates the new late due date for an extension based on course settings.
  # Returns nil if the assignment has no late due date.
  # @return [DateTime, nil]
  def late_due_date
    original_late_due_date = assignment.late_due_date
    return nil if original_late_due_date.blank?

    if extend_late_due_date?
      # Shift the late due date by the same delta as the extension
      extension_delta = request.requested_due_date - assignment.due_date
      original_late_due_date + extension_delta
    else
      # Return the later of the original late due date and the new extended due date
      [original_late_due_date, request.requested_due_date].max
    end
  end

  private

  # Determines whether to extend the late due date by the same delta as the extension.
  # Defaults to true if the setting is nil (for backwards compatibility).
  # @return [Boolean]
  def extend_late_due_date?
    setting = course_settings&.extend_late_due_date
    # Default to true if setting is nil (for backwards compatibility)
    setting.nil? ? true : setting
  end
end
