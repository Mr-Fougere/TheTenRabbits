class CreateSessionRabbits < ActiveRecord::Migration[7.1]
  def change
    create_table :session_rabbits do |t|
      t.references :rabbit, null: false, foreign_key: true
      t.references :session, null: false, foreign_key: true
      t.integer :status, default: 0
      t.string :uuid, null: false
      t.string :key, null: false
      t.boolean :found_animation_played, default: false

      t.timestamps
    end
  end
end
