class CreateAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :assignments do |t|
      t.references :lms, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
