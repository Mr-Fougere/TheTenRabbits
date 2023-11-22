class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.string :uuid, null: false
      t.integer :status, default: 0
      t.boolean :colored_hint, default: false
      t.integer :hint_count, default: 0
      t.references :last_rabbit_talked, null: true, default: nil, foreign_key: { to_table: :rabbits }
      t.datetime :finished_at

      t.timestamps
    end
  end
end
