class AddReadonlyAPITokenToCourses < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :readonly_api_token, :string
    add_index :courses, :readonly_api_token, unique: true
  end
end
