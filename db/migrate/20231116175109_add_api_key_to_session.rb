class AddApiKeyToSession < ActiveRecord::Migration[7.1]
  def change
    add_column :sessions, :api_key, :string, null: false
  end
end
