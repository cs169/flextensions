class SystemUserService
  AUTO_APPROVAL_EMAIL = 'auto_approval@system.com'.freeze
  AUTO_APPROVAL_NAME = 'Automatic Approval System'.freeze
  AUTO_APPROVAL_UID = 'auto_system'.freeze

  # Ensures the auto-approval system user exists, creating it if needed
  # TODO: This should probably be a seed.
  def self.ensure_auto_approval_user_exists
    user = User.find_by(email: AUTO_APPROVAL_EMAIL)

    unless user
      Rails.logger.info 'Creating auto-approval system user'
      user = User.create!(
        email: AUTO_APPROVAL_EMAIL,
        name: AUTO_APPROVAL_NAME,
        canvas_uid: AUTO_APPROVAL_UID
      )
    end

    user
  end

  # Get the auto-approval user, returns nil if it doesn't exist
  def self.auto_approval_user
    User.find_by(email: AUTO_APPROVAL_EMAIL)
  end
end
