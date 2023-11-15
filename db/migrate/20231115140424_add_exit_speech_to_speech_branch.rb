class AddExitSpeechToSpeechBranch < ActiveRecord::Migration[7.1]
  def change
    add_column :speech_branches, :speech_exited, :boolean, default: false
  end
end
