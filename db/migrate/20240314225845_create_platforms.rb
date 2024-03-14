class CreatePlatforms < ActiveRecord::Migration[7.1]
  def change
    create_table :platforms do |t|
      t.string :platform_name
      t.boolean :use_auth_token

      t.timestamps
    end
  end
end
