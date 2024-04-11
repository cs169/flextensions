class CreateUserToCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :user_to_courses do |t|
      t.references :user, foreign_key: true
      t.references :course, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
