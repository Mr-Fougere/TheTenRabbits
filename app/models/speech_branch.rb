class SpeechBranch < ApplicationRecord

    belongs_to :current_speech, class_name: "Speech"
    belongs_to :follow_speech, class_name: "Speech"

end
