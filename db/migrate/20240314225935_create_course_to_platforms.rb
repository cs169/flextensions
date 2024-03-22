class CreateCoursetoplatforms < ActiveRecord::Migration[7.1]
  def change
    create_table :course_to_platforms do |t|
      t.references :platform, foreign_key: true
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
