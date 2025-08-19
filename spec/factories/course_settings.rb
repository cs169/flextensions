# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: course_settings
#
#  id                       :bigint           not null, primary key
#  auto_approve_days        :integer          default(0)
#  auto_approve_dsp_days    :integer          default(0)
#  email_subject            :string           default("Extension Request Status: {{status}} - {{course_code}}")
#  email_template           :text             default("Dear {{student_name}},\n\nYour extension request for {{assignment_name}} in {{course_name}} ({{course_code}}) has been {{status}}.\n\nExtension Details:\n- Original Due Date: {{original_due_date}}\n- New Due Date: {{new_due_date}}\n- Extension Days: {{extension_days}}\n\nIf you have any questions, please contact the course staff.\n\nBest regards,\n{{course_name}} Staff")
#  enable_emails            :boolean          default(FALSE)
#  enable_extensions        :boolean          default(FALSE)
#  enable_slack_webhook_url :boolean
#  max_auto_approve         :integer          default(0)
#  reply_email              :string
#  slack_webhook_url        :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  course_id                :bigint           not null
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

FactoryBot.define do
  factory :course_settings do
    association :course
    enable_extensions { true }
    auto_approve_days { 0 }
  end
end
