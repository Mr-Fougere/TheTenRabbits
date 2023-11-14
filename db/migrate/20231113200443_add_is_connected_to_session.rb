class AddIsConnectedToSession < ActiveRecord::Migration[7.1]
  def change
    add_column :sessions, :is_connected, :boolean, default: false
  end
end
