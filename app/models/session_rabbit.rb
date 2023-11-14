class SessionRabbit < ApplicationRecord
    belongs_to :session
    belongs_to :rabbit

    enum status: { hidden: 0, hinted: 1, waiting_found_animation: 2,found: 3 }

    before_create :setup_credentials
    before_update :found_key_gen, if: -> {saved_change_to_status?(to: "waiting_found_animation")}

    def setup_credentials
        self.uuid = SecureRandom.hex(16) while self.uuid.nil? || SessionRabbit.exists?(uuid: self.uuid)
        self.key = SecureRandom.hex(16)
    end

    def found_key_gen
        self.key = SecureRandom.hex(16) while self.uuid.nil? || SessionRabbit.exists?(uuid: self.uuid)
    end
end