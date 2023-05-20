class AddResponseToChat < ActiveRecord::Migration[7.0]
  def change
    add_column :chats, :response, :string
  end
end
