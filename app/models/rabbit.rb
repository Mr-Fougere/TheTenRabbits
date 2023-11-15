class Rabbit < ApplicationRecord
    include RabbitColors

    has_many :session_rabbits
    has_many :speeches
    has_many :speech_branches, through: :speeches
    
    validates :name, presence: true
    validates :color, presence: true, inclusion: { in: COLORS.keys.map(&:to_s) }

    def hex_color
        COLORS[color.to_sym]
    end

    def underscore_name
        name.underscore
    end
end
