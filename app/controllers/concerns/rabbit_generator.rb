module RabbitGenerator
    extend ActiveSupport::Concern
    
    def bush_generator(number)
        positions = number.times.map do |i|
            {top: rand(10..90), left: rand(10..90), scotty: false}
        end

        return positions unless @session.scotty_introduction?

        scotty_hide = rand(0...number)
        positions[scotty_hide][:scotty] = @session.session_rabbit_named("Scotty")

        positions
    end

end
