class AddStatusToRequests < ActiveRecord::Migration[7.1]
  def change
    create_enum :request_status, ["pending", "approved", "denied"]
    add_column :requests, :status, :enum, enum_type: :request_status, default: "pending", null: false
  end
end
