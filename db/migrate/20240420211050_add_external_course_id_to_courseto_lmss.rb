class AddExternalCourseIdToCoursetoLmss < ActiveRecord::Migration[7.1]
  def change
    add_column :course_to_lmss, :external_course_id, :string
  end
end