class SessionRabbit < ApplicationRecord

    include SessionRabbitSpeech
    
    belongs_to :session
    belongs_to :rabbit
    belongs_to :current_speech, class_name: "Speech", optional: true

    enum status: { hidden: 0, hinted: 1, waiting_found_animation: 2,found: 3 }
    enum speech_status: { no_speech: 0, waiting_answer: 1, talked: 2 }
    enum speech_type: { introduction: 0, random: 1, hint: 2, father: 3 }

    before_create :setup_credentials
    after_update :found_key_gen, if: -> {saved_change_to_status?(to: "waiting_found_animation")}
    after_update :unlock_speeches, if: -> {saved_change_to_status?(to: "found")}


    def broadcast_current_speech
        broadcast_current_speech_bubble
    end

    def broadcast_next_speech(answer)
        next_speech(answer)
        broadcast_current_speech_bubble
    end

    private

    def setup_credentials
        self.uuid = SecureRandom.hex(16) while self.uuid.nil? || SessionRabbit.exists?(uuid: self.uuid)
        self.key = SecureRandom.hex(16)
    end


    def found_key_gen
        update(key: SecureRandom.hex(16))
    end

    def unlock_speeches
        self.speech_status = 'waiting_answer'
        self.current_speech = self.rabbit.speeches.order(:created_at).find_by(speech_type: "introduction")
        self.save
    end

        
    def next_speech(answer)
        return unless current_speech.present?
        return unless speech_status == "waiting_answer"

        speech_branches = current_speech.speech_branches
        
        unless speech_branches.present?
            update(speech_status: "talked")
            return
        end 

        branch_followed = speech_branches.find_by(answer: answer)
        return unless branch_followed.present?

        new_speech = branch_followed.follow_speech
        update(current_speech: new_speech)
    end
end