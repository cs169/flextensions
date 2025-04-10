class AddDueDateAndLateDueDateToAssignments < ActiveRecord::Migration[7.1]
  def change
    add_column :assignments, :due_date, :datetime
    add_column :assignments, :late_due_date, :datetime
  end
end
