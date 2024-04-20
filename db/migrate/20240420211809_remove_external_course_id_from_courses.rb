class RemoveExternalCourseIdFromCourses < ActiveRecord::Migration[7.1]
  def change
    remove_column :courses, :external_course_id, :string
  end
end