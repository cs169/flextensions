class AddEnabledToAssignments < ActiveRecord::Migration[7.1]
  def change
    add_column :assignments, :enabled, :boolean, default: false
  end 
end
