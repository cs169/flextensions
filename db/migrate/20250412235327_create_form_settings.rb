class CreateFormSettings < ActiveRecord::Migration[7.1]
  def up
    # Create a custom PostgreSQL enum type for our _disp columns.
    execute <<-SQL
      CREATE TYPE form_display_status AS ENUM ('required', 'optional', 'hidden');
    SQL

    create_table :form_settings do |t|
      t.references :course, null: false, foreign_key: true

      t.text :reason_desc
      t.text :documentation_desc
      # Use the custom enum type for display columns:
      t.column :documentation_disp, :form_display_status

      t.string :custom_q1
      t.text :custom_q1_desc
      t.column :custom_q1_disp, :form_display_status

      t.string :custom_q2
      t.text :custom_q2_desc
      t.column :custom_q2_disp, :form_display_status

      t.timestamps
    end
  end

  def down
    drop_table :form_settings

    execute <<-SQL
      DROP TYPE form_display_status;
    SQL
  end
end