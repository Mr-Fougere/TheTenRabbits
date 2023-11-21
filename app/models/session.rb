class Session < ApplicationRecord

    before_create :setup_session 

    belongs_to :hinted_rabbit, class_name: "Rabbit", optional: true
    has_many :session_rabbits

    enum status: { initialized:0, in_progress: 1 ,finished: 2}
    enum language: {en: 0, fr: 1, rbt: 2}

    after_update :end_sparky_introduction, if: ->{saved_change_to_status?(to: "in_progress")}
    after_update :end_session, if: ->{saved_change_to_status?(to: "finished")}

    BASIC_RABBITS = ["Sparky","Scotty"]

    def session_rabbit_named(name)
        session_rabbits.joins(:rabbit).find_by(rabbits: {name: name})
    end

    def setup_session
        self[:uuid] = SecureRandom.hex(16) while self[:uuid].blank? || Session.exists?(uuid: self[:uuid])
        self[:api_key] = SecureRandom.hex(16) while self[:api_key].blank?|| Session.exists?(api_key: self[:api_key])
        hide_basic_rabbits
    end

    def found_rabbit(name)
        rabbit = Rabbit.find_by(name: name)
        return unless rabbit

        session_rabbit = self.session_rabbits.hidden.find_by(rabbit: rabbit)
        return unless session_rabbit
        
        session_rabbit.waiting_found_speech!
    end

    def hide_basic_rabbits
        BASIC_RABBITS.each do |rabbit|
            self.session_rabbits.new(rabbit: Rabbit.find_by(name: rabbit))
        end
    end

    def scotty_introduction?
        return false unless self.initialized?

        scotty = self.session_rabbits.find_by(rabbit: Rabbit.find_by(name: "Scotty"))
        return false unless scotty.present?
        return false unless scotty.hidden?

        sparky = self.session_rabbits.find_by(rabbit: Rabbit.find_by(name: "Sparky"))
        return false unless sparky.present?
        return false if sparky.no_speech?
        return false unless sparky.current_speech.text == "introduction-5"

        true
    end

    def hide_remaining_rabbits
        remaining_rabbits = Rabbit.where.not(name: BASIC_RABBITS)
        remaining_rabbits.each do |rabbit|
            session_rabbit = session_rabbits.create(rabbit: rabbit)
            session_rabbit.hide!
        end
    end

    def end_sparky_introduction
        session_sparky =  session_rabbit_named("Sparky")
        next_introduction_speech_id = session_sparky.current_speech.id + 1
        session_sparky.update(speech_status: "waiting_answer", current_speech: session_sparky.speeches.find(next_introduction_speech_id))
        session_sparky.broadcast_current_speech
        hide_remaining_rabbits
    end

    def next_waiting_rabbit
        session_rabbits.waiting_found_speech.order(updated_at: :asc).last
    end

    def end_session
        session_sparky =  session_rabbit_named("Sparky")
        session_sparky.update(speech_type: "found_speech", current_speech: session_sparky.speeches.found.last)
        session_rabbits.each(&:display_rabbit)
        session_sparky.broadcast_current_speech
    end
end
