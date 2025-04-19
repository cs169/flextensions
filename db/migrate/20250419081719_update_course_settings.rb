class UpdateCourseSettings < ActiveRecord::Migration[7.1]
  def change
    remove_column :course_settings, :enable_student_requests, :boolean
    remove_column :course_settings, :auto_approve_days, :integer
    remove_column :course_settings, :auto_approve_dsp_days, :integer
    remove_column :course_settings, :max_auto_approve, :integer
    remove_column :course_settings, :reply_email, :string
    remove_column :course_settings, :email_subject, :string
    remove_column :course_settings, :email_template, :text
    remove_column :course_settings, :enable_emails, :boolean
    remove_column :course_settings, :enable_extensions, :boolean
    remove_column :course_settings, :auto_approve_days_dsp, :integer
    remove_column :course_settings, :email_template_type, :string
    remove_column :course_settings, :email_body, :text


    add_column :course_settings, :enable_extensions, :boolean, default: false
    add_column :course_settings, :auto_approve_days, :integer, default: 0
    add_column :course_settings, :auto_approve_dsp_days, :integer, default: 0
    add_column :course_settings, :max_auto_approve, :integer, default: 0
    add_column :course_settings, :enable_emails, :boolean, default: false
    add_column :course_settings, :reply_email, :string
    add_column :course_settings, :email_subject, :string, default: "Extension Request Status: {{status}} - {{course_code}}"
    add_column :course_settings, :email_template, :text, default: "Dear {{student_name}},\n\nYour extension request for {{assignment_name}} in {{course_name}} ({{course_code}}) has been {{status}}.\n\nExtension Details:\n- Original Due Date: {{original_due_date}}\n- New Due Date: {{new_due_date}}\n- Extension Days: {{extension_days}}\n\nIf you have any questions, please contact the course staff.\n\nBest regards,\n{{course_name}} Staff"
  end
end