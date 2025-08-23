class RenameCourseSettingsOptions < ActiveRecord::Migration[7.2]
  def change
    rename_column :course_settings, :auto_approve_extended_request_days, :auto_approve_extended_request_days
  end
end
