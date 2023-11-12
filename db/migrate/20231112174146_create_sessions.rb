class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.string :uuid, null: false
      t.integer :status, default: 0
      t.boolean :with_colored_hint, default: false
      t.references :hinted_rabbit, null: false, foreign_key: { to_table: :rabbits }
      
      t.timestamps
    end
  end
end
