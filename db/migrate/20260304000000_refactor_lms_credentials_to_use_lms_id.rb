class RefactorLmsCredentialsToUseLmsId < ActiveRecord::Migration[7.1]
  def change
    # Add lms_id column as foreign key without validation
    add_column :lms_credentials, :lms_id, :bigint
    add_foreign_key :lms_credentials, :lmss, column: :lms_id, validate: false

    # Migrate existing data: populate lms_id based on lms_name
    reversible do |dir|
      dir.up do
        safety_assured do
          execute <<-SQL
            UPDATE lms_credentials
            SET lms_id = lmss.id
            FROM lmss
            WHERE LOWER(lms_credentials.lms_name) = LOWER(lmss.lms_name)
          SQL
        end
      end
    end

    # Remove lms_name column (after data migration)
    safety_assured do
      remove_column :lms_credentials, :lms_name, :string
    end
  end
end
