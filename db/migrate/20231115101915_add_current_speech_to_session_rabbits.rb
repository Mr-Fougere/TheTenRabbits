class AddCurrentSpeechToSessionRabbits < ActiveRecord::Migration[7.1]
  def change
    add_reference :session_rabbits, :current_speech, foreign_key: { to_table: :speeches }, null: true
    add_column :session_rabbits , :speech_status, :integer, default: 0
    add_column :session_rabbits , :speech_type, :integer, default: 0
  end
end
