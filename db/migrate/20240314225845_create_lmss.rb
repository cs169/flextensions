class CreateLmss < ActiveRecord::Migration[7.1]
  def change
    create_table :lmss do |t|
      t.string :lms_name
      t.boolean :use_auth_token

      t.timestamps
    end
  end
end
