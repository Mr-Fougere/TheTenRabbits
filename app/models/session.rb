class Session < ApplicationRecord

    before_create :setup_session 

    belongs_to :hinted_rabbit, class_name: "Rabbit", optional: true
    has_many :session_rabbits

    enum status: { initialized:0, in_progress: 1 ,finished: 2}
    enum language: {en: 0, fr: 1, rbt: 2}

    BASIC_RABBITS = ["Sparky","Scotty"]

    def setup_session
        self.uuid = SecureRandom.hex(16) while self.uuid.nil? || Session.exists?(uuid: self.uuid)
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
end
