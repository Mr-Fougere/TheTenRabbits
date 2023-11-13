class AddLanguageToSession < ActiveRecord::Migration[7.1]
  def change
    add_column :sessions, :language, :integer, default: 0
  end
end
