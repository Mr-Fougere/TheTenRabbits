class ApplicationController < ActionController::Base

    before_action :set_session, only: [:home, :continue_session]

    def home
        setup_rabbit_credentials
        p @credentials
        @bushes = bush_generator(7)
    end

    def start_session
        session = Session.create
        cookies[:uuid] = session.uuid
        redirect_to root_path
    end

    def continue_session

    end

    def set_session
        @session = Session.find_by(uuid: cookies[:uuid])
    end

    private 

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
