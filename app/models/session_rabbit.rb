class SessionRabbit < ApplicationRecord

    include SessionRabbitSpeech
    
    belongs_to :session
    belongs_to :rabbit
    belongs_to :current_speech, class_name: "Speech", optional: true

    enum status: { hidden: 0, hinted: 1, waiting_found_animation: 2,found: 3 }
    enum speech_status: { no_speech: 0, waiting_answer: 1, talked: 2 }
    enum speech_type: { introduction: 0, random: 1, hint: 2, enigma: 3, father: 4}

    before_create :setup_credentials
    before_create :set_larry
    after_update :found_key_gen, if: -> {saved_change_to_status?(to: "waiting_found_animation")}
    after_update :found_actions, if: -> {saved_change_to_status?(to: "found")}
    after_update :speeches_after_intro, if: -> {saved_change_to_speech_status?(to: "talked")}

    RABBIT_WITH_HIDE = ["Timmy", "Remmy", "Steevie", "Debbie","Larry"]

    scope :graphic_hidden, -> { joins(:rabbit).where(status: "hidden", rabbit: {name: RABBIT_WITH_HIDE}) }

    def broadcast_current_speech
        return unless current_speech.present? && speech_status != "no_speech"
        
        broadcast_current_speech_bubble
    end

    def broadcast_next_speech(answer)
        exited = current_speech.exit_speech?
        answer = translate_rabbit_language(answer) if is_larry_enigma?
    
        next_speech(answer.underscore)
        return broadcast_speech_status if speech_status == "talked" || exited
        
        broadcast_current_speech_bubble 
    end

    def hide!
        return unless rabbit.name.in?(RABBIT_WITH_HIDE)

        credentials = {uuid: uuid, key: key}
        broadcast_append_to "session-#{session.uuid}", target:"home-#{session.uuid}" , partial: "elements/rabbits/#{rabbit.underscore_name}", locals: { session_rabbit: self }
    end

    def set_larry
        return unless rabbit.name == "Larry"

        self.speech_type = "enigma"
        self.current_speech = rabbit.speeches.enigma.first
        self.speech_status= "waiting_answer"
    end

    def remove_rabbit_from_hide!
        return unless status == "hidden"
        
        case rabbit.name
        when "Timmy"
        when "Remmy"
        when "Steevie"
        when "Debbie"
        when "Larry"
            return broadcast_remove_to "session-#{session.uuid}", target:"#{rabbit.underscore_name}-#{session.uuid}"
        when "Ginny"
        when "Appie"
        when "Scotty"
        when "Sergie"
            return
        end
    end


    private

    def is_larry?
       self.rabbit.name == 'Larry'
    end

    def is_larry_enigma?
        is_larry? && self.current_speech.text.in?(['enigma-1A','enigma-1B'])
    end

    def unlock_scotty
        random_bush = (0..6).to_a.sample
        scotty =  session.session_rabbits.find_by(rabbit: Rabbit.find_by(name: "Scotty"))
        broadcast_update_to "session-#{session.uuid}", target:"bush-#{random_bush}-#{session.uuid}" , partial: 'elements/scotty_hide', locals: {scotty: scotty}
    end

    def larry_friend
        session.found_rabbit("Larry")
    end

    def speeches_after_intro
        unlock_scotty if current_speech&.text == "introduction-5" && rabbit.name == "Sparky"
        larry_friend if current_speech&.text == "enigma-3" && rabbit.name == "Larry"
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
        remove_rabbit_from_hide!
        unlock_speeches
        display_rabbit
        return unless rabbit.name == "Scotty"

        session.in_progress!
    end

    def unlock_speeches
        self.current_speech = self.rabbit.speeches.order(:created_at).find_by(speech_type: "introduction")
        self.speech_status = 'waiting_answer' if self.current_speech.present?
        self.save
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