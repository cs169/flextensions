class AddStudentIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :student_id, :string
  end
end
