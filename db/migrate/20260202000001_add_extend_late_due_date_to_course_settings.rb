class AddExtendLateDueDateToCourseSettings < ActiveRecord::Migration[7.2]
  def change
    add_column :course_settings, :extend_late_due_date, :boolean, default: true, null: false
  end
end
