class AddExtensionsEnabledToAssignments < ActiveRecord::Migration[7.1]
  def change
    add_column :assignments, :extensions_enabled, :boolean
  end
end
