##
# Base class for all extension facades.
class ExtensionFacadeBase
  abstract_class = true

  def initialize(_user_token)
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
  # Provisions a new extension to a user.
  #
  # @param   [Integer] courseId the course to provision the extension in.
  # @param   [Integer] studentId the student to provisoin the extension for.
  # @param   [Integer] assignmentId the assignment the extension should be provisioned for.
  # @param   [String]  newDueDate the date the assignment should be due.
  # @return  [Hash] the extension that was provisioned.
  def provision_extension(courseId, studentId, assignmentId, newDueDate)
    raise NotImplementedError
  end
end
