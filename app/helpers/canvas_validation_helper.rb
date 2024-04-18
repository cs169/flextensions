module CanvasValidationHelper
  OVERRIDE_TITLE_MAX_CHARACTERS = 40

  ##
  # Checks if the provided course id is valid.
  #
  # @param [Integer] courseId the course id to check.
  # @return [Boolean] whether the provided id is valid.
  def is_valid_course_id(courseId)
    courseId.is_a?(Integer) && courseId > 0
  end

  ##
  # Checks if the provided assignment id is valid.
  #
  # @param [Integer] assignmentId the assignment id to check.
  # @return [Boolean] whether the assignment id is valid.
  def is_valid_assignment_id(assignmentId)
    assignmentId.is_a?(Integer) && assignmentId > 0
  end

  ##
  # Checks if the student id is valid.
  #
  # @param [Integer] studentId the student id to check.
  # @return [Boolean] whether the student id is valid.
  def is_valid_student_id(studentId)
    studentId.is_a?(Integer) && studentId > 0
  end

  ##
  # Checks if the list of student ids is valid.
  #
  # @param [Enumerable] the list of student ids to validate.
  # @return [Boolean] whether all student ids in the list are valid.
  def is_valid_student_ids(studentIds)
    studentIds.all? do |studentId|
      is_valid_student_id(studentId)
    end
  end

  ##
  # Checks to see if the provided override title is valid.
  #
  # @param [String] title the title to check.
  # @return [Boolean] whether the title is valid.
  def is_valid_title(title)
    /^[A-Za-z0-9\-_ ]*$/.match?(title) && title.length < OVERRIDE_TITLE_MAX_CHARACTERS
  end

  ##
  # Checks whether the provided date is a valid Canvas date.
  # TODO: maybe want to refine this to actually valid dates not just format?
  #
  # @param [String] date the date string to validate.
  # @return [Boolean] whether the date string is valid.
  def is_valid_date(date)
    if (date == nil)
      return true
    end
    /^[0-9]{4}\-[0-9]{2}\-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$/.match?(date)
  end
end
