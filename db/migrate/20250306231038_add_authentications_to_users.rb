class AddAuthenticationsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :canvas_uid, :string
    add_column :users, :canvas_token, :string
    add_column :users, :name, :string
    add_index :users, :canvas_uid, unique: true
  end
end
