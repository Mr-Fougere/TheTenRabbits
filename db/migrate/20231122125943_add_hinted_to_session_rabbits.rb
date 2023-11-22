class AddHintedToSessionRabbits < ActiveRecord::Migration[7.1]
  def change
    add_column :session_rabbits, :hinted, :boolean, default: false
    remove_column :sessions, :hint_count, :integer
  end
end
