class Session < ApplicationRecord

    before_create :setup_session 

    belongs_to :hinted_rabbit, class_name: "Rabbit", optional: true
    has_many :session_rabbits

    enum status: {initializing:0, seeking: 1, finishing: 2}

    def setup_session
        self.uuid = SecureRandom.hex(16) while self.uuid.nil? || Session.exists?(uuid: self.uuid)
        hide_rabbits
    end

    def hide_rabbits
        Rabbit.all.each do |rabbit|
            self.session_rabbits.new(rabbit: rabbit)
        end
    end
end
