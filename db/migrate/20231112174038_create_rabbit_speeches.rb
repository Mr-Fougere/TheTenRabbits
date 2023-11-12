class CreateRabbitSpeeches < ActiveRecord::Migration[7.1]
  def change
    create_table :rabbit_speeches do |t|
      t.string :text, null: false
      t.json :colored_words, null: false, default: []
      t.references :rabbit, null: false, foreign_key: true
      t.references :next_speech, null: false, foreign_key: { to_table: :rabbit_speeches }

      t.timestamps
    end
  end
end
