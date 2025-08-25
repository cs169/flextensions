class AddInfoToCourseToLms < ActiveRecord::Migration[7.2]
  def change
    add_column :course_to_lmss, :recent_roster_sync, :jsonb, default: {}
    add_column :course_to_lmss, :recent_assignment_sync, :jsonb, default: {}
  end
end
