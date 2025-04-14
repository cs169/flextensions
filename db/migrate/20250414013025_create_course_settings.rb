class CreateCourseSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :course_settings do |t|
      t.references :course, null: false, foreign_key: true
      t.boolean :enable_student_requests, default: false
      t.integer :auto_approve_days
      t.integer :auto_approve_dsp_days
      t.integer :max_auto_approve
      t.string :reply_email
      t.string :email_subject
      t.text :email_template

      t.timestamps
    end
  end
end
