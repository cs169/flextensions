class CreateExtensions < ActiveRecord::Migration[7.1]
  def change
    create_table :extensions do |t|
      t.references :assignment, foreign_key: true
      t.string :student_email
      t.datetime :initial_due_date
      t.datetime :new_due_date
      t.bigint :last_processed_by_user_id

      t.timestamps
    end
  end
end
