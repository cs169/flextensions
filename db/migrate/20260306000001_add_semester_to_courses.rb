class AddSemesterToCourses < ActiveRecord::Migration[7.2]
  def change
    add_column :courses, :semester, :string
  end
end
