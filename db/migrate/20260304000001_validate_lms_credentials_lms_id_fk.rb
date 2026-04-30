class ValidateLmsCredentialsLmsIdFk < ActiveRecord::Migration[7.1]
  def change
    validate_foreign_key :lms_credentials, :lmss
  end
end
