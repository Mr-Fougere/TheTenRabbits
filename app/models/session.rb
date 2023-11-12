class Session < ApplicationRecord

    before_create :setup_session 

    belongs_to :hinted_rabbit, class_name: "Rabbit", optional: true
    has_many :session_rabbits

    enum status: {initializing:0, seeking: 1, finishing: 2}

    def setup_session
        self.uuid = SecureRandom.uuid

    end
end
