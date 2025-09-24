##
# Base class for all extension facades.
#
# The goal of a facade is to provide a consistent interface to different services,
# e.g. to make bCourses and Gradescope operate in the same way (to the rest of the
# the app) even though their APIs are different.
#
# We should have consistent names for all the common methods, though individual
# subclasses will likely implement additional methods.
#
# We have to deal with 'objects', either 'Plain Old Ruby Objects' (POROs) or
# ActiveRecord models, rather than Faraday responses and individual service ids
# as much as possible.
#
#
class LmsFacade
  class LmsAPIError < StandardError; end

  # Every facade must accept at least one optional argument for compatibility.
  # This is usually the user token, or some other value passed to the supporting API.
  def initialize(_user_token = nil)
    raise NotImplementedError
  end

  # It is useful to be able to create an instance from a user object.
  # We expect each facade to implement this method.
  def self.from_user(user)
    # token = user.canvas_token # or however you extract the token
    # new(token)
    raise NotImplementedError
  end

  ##
  # It's not clear whether this needs to exist for all facades.
  # Many APIs paginate responses, and we should be able to use 1 method
  # to handle depagination
  # Typically we will write something like `get_all_courses`
  # Which is a call to some_facade.depaginate_response(some_facade.get_courses)
  def depaginate_response(response)
    raise NotImplementedError
  end

  ##
  # Fetches all assignments from LMS for a given course.
  #
  # @param   [String] external_course_id the external course ID in the LMS.
  # @return  [Array<Lmss::BaseAssignment>] list of assignments.
  def get_all_assignments(external_course_id)
    raise NotImplementedError
  end

  ##
  # Provisions a new extension to a user.
  #
  # @param   [Course] course the course to provision the extension in.
  # @param   [User] student the student to provisoin the extension for.
  # @param   [Assignment] assignment the assignment the extension should be provisioned for.
  # @param   [String]  newDueDate the date the assignment should be due.
  # @return  [Hash] the extension that was provisioned.
  def provision_extension(course, student, assignment, newDueDate)
    raise NotImplementedError
  end
end
