class SessionRabbit < ApplicationRecord
    belongs_to :session
    belongs_to :rabbit

    enum status: { hidden: 0, hinted: 1, found_animation: 2,found: 3 }

    before_create :setup_credentials

    def setup_credentials
        self.uuid = SecureRandom.uuid
        self.key = SecureRandom.hex(32)
    end
end