class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.datetime :requested_due_date
      t.text :reason
      t.text :documentation
      t.text :custom_q1
      t.text :custom_q2
      t.string :external_extension_id

      t.references :course, null: false, foreign_key: true
      t.references :assignment, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :last_processed_by_user, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
