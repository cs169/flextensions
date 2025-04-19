class CreateCourseSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :course_settings do |t|
      t.references :course, null: false, foreign_key: true
      t.boolean :enable_extensions, default: false
      t.integer :auto_approve_days, default: 0
      t.integer :auto_approve_dsp_days, default: 0
      t.integer :max_auto_approve, default: 0
      t.boolean :enable_emails, default: false
      t.string :reply_email
      t.string :email_subject, default: "Extension Request Status: {{status}} - {{course_code}}"
      t.text :email_template, default: "Dear {{student_name}},\n\nYour extension request for {{assignment_name}} in {{course_name}} ({{course_code}}) has been {{status}}.\n\nExtension Details:\n- Original Due Date: {{original_due_date}}\n- New Due Date: {{new_due_date}}\n- Extension Days: {{extension_days}}\n\nIf you have any questions, please contact the course staff.\n\nBest regards,\n{{course_name}} Staff"

      t.timestamps
    end
  end
end 