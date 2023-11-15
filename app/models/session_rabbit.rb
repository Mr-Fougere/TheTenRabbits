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
    after_update :found_actions, if: -> {saved_change_to_status?(to: "found")}
    after_update :speeches_after_intro, if: -> {saved_change_to_speech_status?(to: "talked")}
    after_update :unlock_scotty, if: -> {current_speech&.text == "introduction-5" && saved_change_to_speech_status?(to: "talked") && rabbit.name == "Sparky"}

    def broadcast_current_speech
        broadcast_current_speech_bubble
    end

    def broadcast_next_speech(answer)
        exited = current_speech.exit_speech?
        next_speech(answer)
        return broadcast_speech_status if speech_status == "talked" || exited
        
        broadcast_current_speech_bubble 
    end

    private

    def unlock_scotty
        random_bush = (0..6).to_a.sample
        scotty =  session.session_rabbits.find_by(rabbit: Rabbit.find_by(name: "Scotty"))
        broadcast_update_to "session-#{session.uuid}", target:"bush-#{random_bush}-#{session.uuid}" , partial: 'elements/scotty_hide', locals: {scotty: scotty}
    end

    def speeches_after_intro
        return unless speech_type == "introduction" && last_introduction_speech?

        new_type = rabbit.name == "Sparky" ? "hint" : "random"
        new_speech = rabbit.speeches.where(speech_type: new_type).first
        update(speech_type: new_type, current_speech: new_speech , speech_status: "waiting_answer")
    end

    def last_introduction_speech?
        rabbit.speeches.where(speech_type: "introduction").last == current_speech
    end

    def setup_credentials
        self.uuid = SecureRandom.hex(16) while self.uuid.nil? || SessionRabbit.exists?(uuid: self.uuid)
        self.key = SecureRandom.hex(16)
    end


    def found_key_gen
        update(key: SecureRandom.hex(16))
    end

    def found_actions
        remove_rabbit_from_hide 
        display_rabbit
        unlock_speeches
        hide_remaining_rabbits if rabbit.name == "Scotty"
    end

    def unlock_speeches
        self.speech_status = 'waiting_answer'
        self.current_speech = self.rabbit.speeches.order(:created_at).find_by(speech_type: "introduction")
        self.save
    end

    def hide_remaining_rabbits
        
    end

    def remove_rabbit_from_hide
        case rabbit.name
        when "Ginny"
        when "Appie"
        when "Sparky"
        when "Timmy"
        when "Larry"
        when "Scotty"
        when "Sergie"
        when "Remmy"
        when "Steevie"
        when "Debbie"
            return
        end
    end

    def display_rabbit
        broadcast_append_to "session-#{session.uuid}", target:"home-#{session.uuid}" , partial: "elements/rabbit_found", locals: { session_rabbit: self }
    end
 
    def next_speech(answer)
        return unless current_speech.present?
        return unless speech_status != "no_speech"

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