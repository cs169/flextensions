class RemoveCanvasTokenFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :canvas_token, :string
  end
end
