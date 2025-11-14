class AddLmsBaseUrlToLmss < ActiveRecord::Migration[7.2]
  def change
    add_column :lmss, :lms_base_url, :string
  end
end
