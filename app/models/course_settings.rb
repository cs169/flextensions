class CourseSettings < ApplicationRecord
  belongs_to :course

  before_save :ensure_system_user_for_auto_approval

  private

  def ensure_system_user_for_auto_approval
    # Create the system user if auto-approval is being enabled
    return unless enable_extensions && auto_approve_days.to_i.positive?

    SystemUserService.ensure_auto_approval_user_exists
  end
end
