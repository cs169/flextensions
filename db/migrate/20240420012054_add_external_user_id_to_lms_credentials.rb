class AddExternalUserIdToLmsCredentials < ActiveRecord::Migration[7.1]
  def change
    add_column :lms_credentials, :external_user_id, :string
  end
end
