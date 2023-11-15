class Speech < ApplicationRecord
    enum speech_type: { introduction: 0, random: 1, hint: 2, father: 3 } 

    has_many :speech_branches, foreign_key: :current_speech_id, dependent: :destroy
    has_many :follow_speeches, through: :speech_branches, source: :follow_speech

    belongs_to :rabbit
    

end
