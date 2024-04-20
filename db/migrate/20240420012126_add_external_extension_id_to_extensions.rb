class AddExternalExtensionIdToExtensions < ActiveRecord::Migration[7.1]
  def change
    add_column :extensions, :external_extension_id, :string
  end
end
