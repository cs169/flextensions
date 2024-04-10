class CreateLmsCredentials < ActiveRecord::Migration[7.1]
  def change
    create_table :lms_credentials do |t|
      t.references :user, foreign_key: true
      t.string :lms_name
      t.string :username
      t.string :password
      t.string :token
      t.string :refresh_token

      t.timestamps
    end
  end
end
