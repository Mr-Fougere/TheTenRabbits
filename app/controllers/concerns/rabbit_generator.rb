module RabbitGenerator
    extend ActiveSupport::Concern
    
    def setup_rabbit_credentials
        rabbits = ["Scotty","Steevie","Remmy","Debbie"]
        rabbits.push("Sergie") if request.url.exclude?("https")
        @credentials = @session.rabbits_credentials(rabbits)
    end

    def bush_generator(number)
        positions = number.times.map do |i|
            {top: rand(10..90), left: rand(10..90), key: SecureRandom.hex(16), uuid: SecureRandom.hex(16), is_rabbit_hide: false}
        end
        scotty_hide = rand(0...number)
        scotty_key = @credentials[:scotty][:key]
        scotty_uuid = @credentials[:scotty][:uuid]
        positions[scotty_hide][:is_rabbit_hide] = true
        positions[scotty_hide][:key] = scotty_key
        positions[scotty_hide][:uuid] = scotty_uuid
        positions
    end

end
