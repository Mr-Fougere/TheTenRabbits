class SessionRabbit < ApplicationRecord
    belongs_to :session
    belongs_to :rabbit

    enum status: { hidden: 0, hinted: 1, waiting_found_animation: 2,found: 3 }

    before_create :setup_credentials

    def setup_credentials
        self.uuid = SecureRandom.hex(16) while self.uuid.nil? || SessionRabbit.exists?(uuid: self.uuid)
        self.key = SecureRandom.hex(16)
    end
end