class CreateSpeeches < ActiveRecord::Migration[7.1]
  def change
    create_table :speeches do |t|
      t.string :text, null: false
      t.integer :speech_type, default: 0
      t.json :colored_words, null: true, default: {}
      t.references :rabbit, foreign_key: true, null: false

      t.timestamps
    end
  end
end
