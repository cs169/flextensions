class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :canvas_uid
      t.string :name
      t.string :canvas_token
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :canvas_uid, unique: true
  end
end
