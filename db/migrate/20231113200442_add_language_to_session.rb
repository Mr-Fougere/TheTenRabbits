class AddLanguageToSession < ActiveRecord::Migration[7.1]
  def chang
    add_column :sessions, :language, :integer, default: 0
  end
end
