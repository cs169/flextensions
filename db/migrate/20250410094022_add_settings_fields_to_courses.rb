class AddSettingsFieldsToCourses < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :enable_student_requests, :boolean
    add_column :courses, :auto_approve_days, :integer
    add_column :courses, :auto_approve_dsp_days, :integer
    add_column :courses, :max_auto_approve, :integer
    add_column :courses, :reply_email, :string
    add_column :courses, :custom_question_1, :text
    add_column :courses, :custom_question_2, :text
    add_column :courses, :custom_question_3, :text
    add_column :courses, :email_subject, :string
    add_column :courses, :email_template, :text
  end
end
