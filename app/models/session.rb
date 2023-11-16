class Session < ApplicationRecord

    before_create :setup_session 

    belongs_to :hinted_rabbit, class_name: "Rabbit", optional: true
    has_many :session_rabbits

    enum status: { initialized:0, in_progress: 1 ,finished: 2}
    enum language: {en: 0, fr: 1, rbt: 2}

    after_update :end_sparky_introduction, if: ->{saved_change_to_status?(to: "in_progress")}

    BASIC_RABBITS = ["Sparky","Scotty"]

    def session_rabbit_named(name)
        session_rabbits.joins(:rabbit).find_by(rabbits: {name: name})
    end

    def setup_session
        uuid = SecureRandom.hex(16) while uuid.nil? || Session.exists?(uuid: uuid)
        api_key = SecureRandom.hex(16) while api_key.nil? || Session.exists?(api_key: api_key)
        hide_basic_rabbits
    end

    def found_rabbit(name)
        rabbit = Rabbit.find_by(name: name)
        return unless rabbit

        session_rabbit = self.session_rabbits.find_by(rabbit: rabbit)
        return unless session_rabbit

        session_rabbit.waiting_found_animation!
    end

    def hide_basic_rabbits
        BASIC_RABBITS.each do |rabbit|
            self.session_rabbits.new(rabbit: Rabbit.find_by(name: rabbit))
        end
    end

    def rabbits_credentials(names)
        rabbits = Rabbit.where(name: names)
        credentials = {}
        rabbits.each do |rabbit|
            session_rabbit = self.session_rabbits.find_by(rabbit: rabbit)
            credentials[rabbit.name.downcase.to_sym] = {key: nil, uuid: nil}
            next unless session_rabbit
            
            credentials[rabbit.name.downcase.to_sym][:key] = session_rabbit.key
            credentials[rabbit.name.downcase.to_sym][:uuid] = session_rabbit.uuid
        end
        credentials
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
        sparky = Rabbit.find_by(name: "Sparky")
        session_sparky =  session_rabbits.find_by(rabbit: sparky )
        session_sparky.update(speech_status: "waiting_answer", current_speech: sparky.speeches.find(session_sparky.current_speech.id + 1))
        session_sparky.broadcast_current_speech
        hide_remaining_rabbits
    end
end
