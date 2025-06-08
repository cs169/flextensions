class AddGradescopeToCourseSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :course_settings, :enable_gradescope, :boolean, default: false
    add_column :course_settings, :gradescope_course_url, :string
  end
end
