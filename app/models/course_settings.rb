class CourseSettings < ApplicationRecord
  belongs_to :course

  before_save :ensure_system_user_for_auto_approval
  validate :gradescope_url_is_valid, if: :enable_gradescope?

  private

  def ensure_system_user_for_auto_approval
    # Create the system user if auto-approval is being enabled
    return unless enable_extensions && auto_approve_days.to_i.positive?

    SystemUserService.ensure_auto_approval_user_exists
  end

  def gradescope_url_is_valid
    return if gradescope_course_url.match?(%r{\Ahttps://(www\.)?gradescope\.com/courses/\d{6}\z})

    errors.add(:gradescope_course_url, 'must be a valid Gradescope course URL like https://gradescope.com/courses/123456')
  end
end
