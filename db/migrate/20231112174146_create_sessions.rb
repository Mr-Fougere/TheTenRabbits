class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.string :uuid, null: false
      t.integer :status, default: 0
      t.references :current_advice, null: false, foreign_key: { to_table: :rabbit_speeches }
      
      t.timestamps
    end
  end
end
