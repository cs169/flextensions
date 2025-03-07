class RemoveEmailIndexFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_index :users, column: :email
  end
end
