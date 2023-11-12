class Rabbit < ApplicationRecord
    include RabbitColors

    has_many :session_rabbits
    
    validates :name, presence: true
    validates :color, presence: true, inclusion: { in: COLORS.keys.map(&:to_s) }

    def hex_color
        COLORS[color.to_sym]
    end
end
