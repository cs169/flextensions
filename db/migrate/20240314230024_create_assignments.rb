class CreateAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :assignments do |t|
      t.references :platform, foreign_key: true
      t.string :assignment_name

      t.timestamps
    end
  end
end
