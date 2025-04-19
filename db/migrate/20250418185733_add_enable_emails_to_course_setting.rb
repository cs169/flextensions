class AddEnableEmailsToCourseSetting < ActiveRecord::Migration[7.1]
  def change
    add_column :course_settings, :enable_emails, :boolean, default: false
  end
end
