class AddCourseCodeToCourses < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :course_code, :string
  end
end
