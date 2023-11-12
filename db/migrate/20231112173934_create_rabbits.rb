class CreateRabbits < ActiveRecord::Migration[7.1]
  def change
    create_table :rabbits do |t|
      t.string :name, null: false
      t.integer :color, null: false
      t.integer :difficulty, null: false, default: 0

      t.timestamps
    end
  end
end
