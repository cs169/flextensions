class AddNotesToUserToCourses < ActiveRecord::Migration[7.2]
  def change
    add_column :user_to_courses, :notes, :text
  end
end
