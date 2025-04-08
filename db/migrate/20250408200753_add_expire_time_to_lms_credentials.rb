class AddExpireTimeToLmsCredentials < ActiveRecord::Migration[7.1]
  def change
    add_column :lms_credentials, :expire_time, :datetime
  end
end
