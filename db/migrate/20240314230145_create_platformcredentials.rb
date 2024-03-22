class CreatePlatformcredentials < ActiveRecord::Migration[7.1]
  def change
    create_table :platform_credentials do |t|
      t.references :user, foreign_key: true
      t.string :platform_name
      t.string :username
      t.string :password
      t.string :token

      t.timestamps
    end
  end
end
