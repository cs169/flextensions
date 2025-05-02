class AddAutoApprovedToRequests < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:requests, :auto_approved)
      add_column :requests, :auto_approved, :boolean, default: false, null: false
      add_index :requests, :auto_approved
    end
  end
end
