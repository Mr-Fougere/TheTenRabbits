class Rabbit < ApplicationRecord
    include RabbitColors
    
    has_many :rabbit_speeches
    
    def hex_color
        COLORS[color.to_sym]
    end
end
