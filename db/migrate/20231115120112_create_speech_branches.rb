class CreateSpeechBranches < ActiveRecord::Migration[7.1]
  def change
    create_table :speech_branches do |t|
      t.references :current_speech, foreign_key: {to_table: :speeches}, null: false
      t.references :follow_speech, foreign_key: {to_table: :speeches}, null: false
      t.string :answer, default: "next"
      
      t.timestamps
    end
  end
end
