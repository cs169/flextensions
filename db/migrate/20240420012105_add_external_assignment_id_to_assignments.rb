class AddExternalAssignmentIdToAssignments < ActiveRecord::Migration[7.1]
  def change
    add_column :assignments, :external_assignment_id, :string
  end
end
