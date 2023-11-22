class SessionRabbit < ApplicationRecord

    include SessionRabbitSpeech
    
    belongs_to :session
    belongs_to :rabbit
    belongs_to :current_speech, class_name: "Speech", optional: true
    has_many :speeches, through: :rabbit

    enum status: { hidden: 0, waiting_found_speech: 1, found: 2 }

    enum speech_status: { no_speech: 0, waiting_answer: 1, talked: 2 }
    enum speech_type: { introduction: 0, random: 1, hint: 2, enigma: 3, found_speech: 4}

    before_create :setup_credentials
    before_create :set_larry
    after_update :waiting_found_actions, if: -> {saved_change_to_status?(to: "waiting_found_speech")}
    after_update :speeches_after_intro, if: -> {saved_change_to_speech_status?(to: "talked")}

    RABBIT_WITH_HIDE = ["Timmy", "Remmy", "Steevie", "Debbie","Larry","Ginny","Scotty"]

    scope :graphic_hidden, -> { joins(:rabbit).where(status: "hidden", rabbit: {name: RABBIT_WITH_HIDE}) }
    scope :hinted, -> { where(hinted: true) }
    
    def broadcast_current_speech
        return unless current_speech.present? && speech_status != "no_speech"
        remove_last_speech_bubble unless same_rabbit_speech?
        broadcast_current_speech_bubble
    end

    def broadcast_next_speech(answer)
        exited = current_speech.exit_speech?
        answer = translate_rabbit_language(answer) if is_larry_enigma?

        if current_speech.speech_type == "found" && rabbit.name == "Sparky"

            current_waiting_rabbit = session.next_waiting_rabbit
            current_waiting_rabbit.found! if current_waiting_rabbit
            next_waiting_rabbit = session.next_waiting_rabbit
            rabbits_found = session.session_rabbits.found
            return session.finished! if rabbits_found.count == 10
            return next_waiting_rabbit.broadcast_found_speech if next_waiting_rabbit && next_waiting_rabbit != self

            self.update(speech_type: "hint")
        end

        next_speech(answer.underscore)
        return broadcast_speech_status if speech_status == "talked" || exited
        
        broadcast_current_speech_bubble 
    end

    def broadcast_found_speech
        session_sparky = session.session_rabbit_named("Sparky")
        return unless session_sparky.present? && session_sparky != self
        return update(status: "found") if session_sparky.speech_status == "introduction" 

        found_speech = session_sparky.rabbit.speeches.found.find_by(text: "found-#{self.rabbit.underscore_name}")
        session_sparky.update(speech_status: "waiting_answer",speech_type: "found_speech", current_speech: found_speech)
        session_sparky.broadcast_current_speech
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
        return if status == "hidden"
        return unless rabbit.name.in?(RABBIT_WITH_HIDE)
        
        broadcast_remove_to "session-#{session.uuid}", target:"#{rabbit.underscore_name}-#{session.uuid}"
    end

    def display_rabbit(out = false)
        broadcast_append_to "session-#{session.uuid}", target:"home-#{session.uuid}" , partial: "elements/rabbit_found", locals: { session_rabbit: self, out: out }
    end

    private

    def sparky_rabbit_hint? 
        p rabbit.name == "Sparky"
        p speech_type == "hint"
        return unless rabbit.name == "Sparky"
        return unless speech_type == "hint"
        p ["hint-no-thanks","hint-1"].include?(current_speech.text)
        return if ["hint-no-thanks","hint-1"].include?(current_speech.text)

        true
    end

    def rabbit_hinted
        rabbit_name = current_speech.text.match(/[^-]+$/)[0]
        p rabbit_name
        return unless rabbit_name

        session.session_rabbit_named(rabbit_name.capitalize).update(hinted: true)
    end

    def same_rabbit_speech?
        return true if session.last_rabbit_talked.nil?

        session.last_rabbit_talked == self.rabbit
    end

    def is_larry?
       self.rabbit.name == 'Larry'
    end

    def is_larry_enigma?
        is_larry? && self.current_speech.text.in?(['enigma-1A','enigma-1B'])
    end

    def unlock_scotty
        random_bush = (0..6).to_a.sample
        scotty =  session.session_rabbits.find_by(rabbit: Rabbit.find_by(name: "Scotty"))
        broadcast_update_to "session-#{session.uuid}", target:"bush-#{random_bush}-#{session.uuid}" , partial: 'elements/scotty_hide', locals: {session_rabbit: scotty}
    end

    def larry_friend
        session.found_rabbit("Larry")
    end

    def speeches_after_intro
        unlock_scotty if current_speech&.text == "introduction-5" && rabbit.name == "Sparky"
        larry_friend if current_speech&.text == "enigma-3" && rabbit.name == "Larry"
        return unless speech_type == "introduction" && last_introduction_speech?
        is_sparky =rabbit.name == "Sparky"
        new_type = is_sparky ? "hint" : "random"
        speech_filter = is_sparky ? "first" : "sample"
        new_speech = rabbit.speeches.where(speech_type: new_type).public_send(speech_filter)
        update(speech_type: new_type, current_speech: new_speech , speech_status: "waiting_answer")
    end

    def last_introduction_speech?
        rabbit.speeches.where(speech_type: "introduction").last == current_speech
    end

    def setup_credentials
        self.uuid = SecureRandom.hex(16) while self.uuid.nil? || SessionRabbit.exists?(uuid: self.uuid)
        self.key = SecureRandom.hex(16)
    end

    def waiting_found_actions
        remove_rabbit_from_hide!
        unlock_speeches
        display_rabbit
        broadcast_found_speech unless rabbit.name.in?(["Sparky","Scotty"])
        return unless rabbit.name == "Scotty"
        
        self.found!
        session.in_progress!
    end

    def unlock_speeches
        self.speech_type = "introduction"
        self.current_speech = self.rabbit.speeches.order(:created_at).find_by(speech_type: "introduction")
        self.speech_status = 'waiting_answer' if self.current_speech.present?
        self.save
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