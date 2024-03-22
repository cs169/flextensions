class CreateExtensions < ActiveRecord::Migration[7.1]
  def change
    create_table :extensions do |t|
      t.references :assignment, foreign_key: true
      t.string :student_email
      t.datetime :initial_due_date
      t.datetime :new_due_date
      t.references :users, foreign_key: true

      t.timestamps
    end
    rename_column :extensions, :users_id, :last_processed_by_id
  end
end
