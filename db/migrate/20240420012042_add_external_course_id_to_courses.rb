class AddExternalCourseIdToCourses < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :external_course_id, :string
  end
end
