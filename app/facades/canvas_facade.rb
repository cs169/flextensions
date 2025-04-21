require 'date'
require 'faraday'
require 'json'
require 'ostruct'

##
# This is the facade for Canvas.
class CanvasFacade < ExtensionFacadeBase
  CANVAS_URL = ENV.fetch('CANVAS_URL', nil)

  ##
  # Configures the facade with the canvas api endpoint configured in the environment.
  #
  # @param [String]              masqueradeToken the token of the user to masquerade as.
  # @param [Faraday::Connection] conn            existing connection to use (defaults to nil).
  def initialize(masqueradeToken, conn = nil)
    @canvasApi = conn || Faraday.new(
      url: "#{CanvasFacade::CANVAS_URL}/api/v1",
      headers: {
        Authorization: "Bearer #{masqueradeToken}"
      }
    )
  end

  ##
  # Gets all courses for the authorized user.
  #
  # @return [Faraday::Response] list of the courses the user has access to.
  def get_all_courses
    @canvasApi.get('courses')
  end

  ##
  # Gets a specified course that the authorized user has access to.
  #
  # @param  [Integer] courseId the course id to look up.
  # @return [Faraday::Response] information about the requested course.
  def get_course(courseId)
    @canvasApi.get("courses/#{courseId}")
  end

  ##
  # Gets a list of assignments for a specified course.
  #
  # @param  [Integer]    courseId the course id to fetch the assignments of.
  # @return [Faraday::Response] list of the assignments in the course.
  def get_assignments(courseId)
    @canvasApi.get("courses/#{courseId}/assignments")
  end

  ##
  # Gets a specified assignment from a course.
  #
  # @param  [Integer] courseId     the course to fetch the assignment from.
  # @param  [Integer] assignmentId the id of the assignment to fetch.
  # @return [Faraday::Response] information about the requested assignment.
  def get_assignment(courseId, assignmentId)
    @canvasApi.get("courses/#{courseId}/assignments/#{assignmentId}")
  end

  ##
  # Gets a list of the assignment overrides for a specified assignment.
  #
  # @param   [Integer]    courseId     the course to fetch the overrides from.
  # @param   [Integer]    assignmentId the assignment to fetch the overrides from.
  # @return  [Faraday::Response] all of the overrides for the specified assignment.
  def get_assignment_overrides(courseId, assignmentId)
    @canvasApi.get("courses/#{courseId}/assignments/#{assignmentId}/overrides")
  end

  ##
  # Creates a new assignment override.
  #
  # @param   [Integer]    courseId     the id of the course to create the override for.
  # @param   [Integer]    assignmentId the id of the assignment to create the override for.
  # @param   [Enumerable] studentIds   the student ids to provision the override to.
  # @param   [String]     title        the title of the new override.
  # @param   [String]     dueDate      the new due date for the override.
  # @param   [String]     unlockDate   the date the override should unlock the assignment.
  # @param   [String]     lockDate     the date the override should lock the assignment.
  # @return  [Faraday::Response] information about the new override.
  def create_assignment_override(courseId, assignmentId, studentIds, title, dueDate, unlockDate, lockDate)
    @canvasApi.post("courses/#{courseId}/assignments/#{assignmentId}/overrides", {
                      assignment_override: {
                        student_ids: studentIds,
                        title: title,
                        due_at: dueDate,
                        unlock_at: unlockDate,
                        lock_at: lockDate
                      }
                    })
  end

  ##
  # Updates an existing assignment override.
  #
  # @param   [Integer]    courseId     the id of the course to update the override for.
  # @param   [Integer]    assignmentId the id of the assignment to update the override for.
  # @param   [Enumerable] studentIds   the updated student ids to provision the override to.
  # @param   [String]     title        the updated title of the override.
  # @param   [String]     dueDate      the updated due date for the override.
  # @param   [String]     unlockDate   the updated date the override should unlock the assignment.
  # @param   [String]     lockDate     the updated date the override should lock the assignment.
  # @return  [Faraday::Response] information about the updated override.
  def update_assignment_override(courseId, assignmentId, overrideId, studentIds, title, dueDate, unlockDate, lockDate)
    @canvasApi.put("courses/#{courseId}/assignments/#{assignmentId}/overrides/#{overrideId}", {
                     student_ids: studentIds,
                     title: title,
                     due_at: dueDate,
                     unlock_at: unlockDate,
                     lock_at: lockDate
                   })
  end

  ##
  # Deletes an assignment override.
  #
  # @param  [Integer] courseId the id of the course where the override to delete is provisioned.
  # @param  [Integer] assignmentId the assignment for which the override to delete is provisioned.
  # @param  [Integer] overrideId the id of the override to delete.
  # @return [Faraday::Response] information about the deleted override.
  def delete_assignment_override(courseId, assignmentId, overrideId)
    @canvasApi.delete("courses/#{courseId}/assignments/#{assignmentId}/overrides/#{overrideId}")
  end

  ##
  # Provisions a new extension to a user.
  #
  # @param   [Integer] courseId the course to provision the extension in.
  # @param   [Integer] studentId the student to provisoin the extension for.
  # @param   [Integer] assignmentId the assignment the extension should be provisioned for.
  # @param   [String]  newDueDate the date the assignment should be due.
  # @return  [Faraday::Response] the override that acts as the extension.
  # @raises  [FailedPipelineError] if the creation response body could not be parsed.
  # @raises  [NotFoundError]       if the user has an existing override that cannot be located.
  def provision_extension(courseId, studentId, assignmentId, newDueDate)
    overrideTitle = "#{studentId} extended to #{newDueDate}"
    createOverrideResponse = create_assignment_override(
      courseId,
      assignmentId,
      [studentId],
      overrideTitle,
      newDueDate,
      get_current_formatted_time,
      newDueDate
    )
    # Either successful or error that is not explicitly handled here.
    return createOverrideResponse if createOverrideResponse.status != 400

    decodedCreateOverrideResponseBody = nil
    begin
      decodedCreateOverrideResponseBody = JSON.parse(createOverrideResponse.body, object_class: OpenStruct)
    rescue JSON::ParserError
      raise FailedPipelineError.new('Update Student Extension', 'Parse Creation Response')
    end
    # This only fails if the student already has an override provisioned to them.
    if decodedCreateOverrideResponseBody&.errors
                                        &.assignment_override_students&.any? { |studentError| studentError&.type != 'taken' }

      return createOverrideResponse
    end

    currOverride = get_existing_student_override(courseId, studentId, assignmentId)
    raise NotFoundError, 'could not find student\'s override' if currOverride.nil?

    if currOverride.student_ids.length == 1
      return update_assignment_override(
        courseId,
        assignmentId,
        currOverride.id,
        currOverride.student_ids,
        overrideTitle,
        newDueDate,
        get_current_formatted_time,
        newDueDate
      )
    end
    remove_student_from_override(courseId, currOverride, studentId)
    create_assignment_override(
      courseId,
      assignmentId,
      [studentId], overrideTitle,
      newDueDate,
      get_current_formatted_time,
      newDueDate
    )
  end

  private

  ##
  # Gets the existing override for a student.
  #
  # @param  [Integer] courseId the courseId to check for an existing override.
  # @param  [Integer] studentId the student to check for an existing override for.
  # @param  [Integer] assignmentId the assignmnet to check for an existing override for.
  # @return [OpenStruct|nil] the override if it is found or nil if not.
  # @throws [FailedPipelineError] if the existing overrides response body could not be parsed.
  def get_existing_student_override(courseId, studentId, assignmentId)
    begin
      allAssignmentOverrides = JSON.parse(
        get_assignment_overrides(courseId, assignmentId).body,
        object_class: OpenStruct
      )
    rescue JSON::ParserError
      raise FailedPipelineError.new(
        'Update Student Extension',
        'Get Existing Student Override',
        'Parse Canvas Response'
      )
    end

    allAssignmentOverrides.each do |override|
      return override if override&.student_ids&.include?(studentId)
    end
    nil
  end

  ##
  # Gets the current time as formatted for Canvas's version of iso8601.
  #
  # @return [String] the current time that Canvas likes.
  def get_current_formatted_time
    currDateTimeUnformatted = DateTime.now.utc.iso8601
    # This is some weird format of iso8601 standard that Canvas likes... Don't ask me.
    "#{/[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}/.match(currDateTimeUnformatted)[0]}Z"
  end

  ##
  # Removes a student from an existing override.
  #
  # @param   [Integer]    courseId the courseId to remove the student from the override of.
  # @param   [OpenStruct] override the existing override to remove the student from.
  # @param   [Integer]    studentId the id of the student to remove from the override.
  # @return  [Faraday::Response] the new override if successful.
  # @raises  [FailedPipelineError] if the student could not be removed from the override.
  def remove_student_from_override(courseId, override, studentId)
    override.student_ids.delete(studentId)
    res = update_assignment_override(
      courseId,
      override.assignment_id,
      override.id,
      override.student_ids,
      override.title,
      override.due_at,
      override.unlock_at,
      override.lock_at
    )
    decodedBody = JSON.parse(res.body, object_class: OpenStruct)
    if decodedBody&.student_ids&.include?(studentId)
      raise FailedPipelineError.new(
        'Update Student Extension',
        'Remove Student from Existing Override',
        'Could not remove student'
      )
    end
    res
  end
end
