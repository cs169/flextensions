class AddCanvasIdToCourses < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :canvas_id, :string
    add_index :courses, :canvas_id, unique: true
  end
end
