# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: course_settings
#
#  id                                 :bigint           not null, primary key
#  auto_approve_days                  :integer          default(0)
#  auto_approve_extended_request_days :integer          default(0)
#  email_subject                      :string           default("Extension Request Status: {{status}} - {{course_code}}")
#  email_template                     :text             default("Dear {{student_name}},\n\nYour extension request for {{assignment_name}} in {{course_name}} ({{course_code}}) has been {{status}}.\n\nExtension Details:\n- Original Due Date: {{original_due_date}}\n- New Due Date: {{new_due_date}}\n- Extension Days: {{extension_days}}\n\nIf you have any questions, please contact the course staff.\n\nBest regards,\n{{course_name}} Staff")
#  enable_emails                      :boolean          default(FALSE)
#  enable_extensions                  :boolean          default(FALSE)
#  enable_gradescope                  :boolean          default(FALSE)
#  enable_slack_webhook_url           :boolean
#  extend_late_due_date               :boolean          default(TRUE), not null
#  gradescope_course_url              :string
#  max_auto_approve                   :integer          default(0)
#  reply_email                        :string
#  slack_webhook_url                  :string
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  course_id                          :bigint           not null
#
# Indexes
#
#  index_course_settings_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
# rubocop:enable Layout/LineLength

class CourseSettings < ApplicationRecord
  # TODO: Remove the db default text, and use an AR validation.
  DEFAULT_EMAIL_TEMPLATE = <<~LIQUID.freeze
    Hello {{student_name}},

    Your extension request for {{assignment_name}} in {{course_name}} ({{course_code}}) has been {{status}}.

    Extension Details:
    - Original Due Date: {{original_due_date}}
    - New Due Date: {{new_due_date}}
    - Extension Days: {{extension_days}}

    If you have any questions, please reach out to your course staff.

    Thank you,
    {{course_name}} Staff
  LIQUID

  belongs_to :course

  before_save :ensure_system_user_for_auto_approval
  validate :gradescope_url_is_valid, if: :enable_gradescope?
  after_save :create_or_update_gradescope_link

  def ensure_system_user_for_auto_approval
    # Create the system user if auto-approval is being enabled
    return unless enable_extensions && auto_approve_days.to_i.positive?

    SystemUserService.ensure_auto_approval_user_exists
  end

  VALID_GRADESCOPE_URL = %r{\Ahttps://(www\.)?gradescope\.com/courses/\d+/?\z}

  # TODO: if disabled should unsync Gradescope assignments
  def create_or_update_gradescope_link
    if course.course_settings.enable_gradescope
      gradescope_course_id = extract_gradescope_course_id(course.course_settings.gradescope_course_url)
      CourseToLms.find_or_initialize_by(course_id: course.id, lms_id: GRADESCOPE_LMS_ID).tap do |course_to_lms|
        course_to_lms.external_course_id = gradescope_course_id
        course_to_lms.save!
      end
    end
  end

  def gradescope_url_is_valid
    return if gradescope_course_url.match?(VALID_GRADESCOPE_URL)

    errors.add(:gradescope_course_url, 'must be a valid Gradescope course URL like https://gradescope.com/courses/123456')
  end

  def extract_gradescope_course_id(gradescope_course_url)
    match = gradescope_course_url.match(%r{gradescope\.com/courses/(\d+)})
    match[1]
  end
end
