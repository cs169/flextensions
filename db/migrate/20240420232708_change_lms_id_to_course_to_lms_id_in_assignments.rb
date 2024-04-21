class ChangeLmsIdToCourseToLmsIdInAssignments < ActiveRecord::Migration[7.1]
  def change
    remove_index :assignments, :lms_id
    remove_column :assignments, :lms_id, :bigint
    add_column :assignments, :course_to_lms_id, :bigint, null: false
    add_index :assignments, :course_to_lms_id
    add_foreign_key :assignments, :course_to_lmss, column: :course_to_lms_id
  end
end
