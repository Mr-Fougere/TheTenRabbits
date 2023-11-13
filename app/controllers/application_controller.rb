class ApplicationController < ActionController::Base

    before_action :set_session, only: [:home, :continue_session]

    def home
        setup_rabbit_credentials
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
        debbie_credentials = @session.rabbit_credentials("Debbie")
        remy_credentials = @session.rabbit_credentials("Remmy")
        steevie_credentials = @session.rabbit_credentials("Steevie")    
        @debbie_key = debbie_credentials[:rabbit_key]
        @debbie_uuid = debbie_credentials[:rabbit_uuid]
        @steevie_key = steevie_credentials[:rabbit_key]
        @steevie_uuid = steevie_credentials[:rabbit_uuid]
        @remy_key = remy_credentials[:rabbit_key]
        @remy_uuid = remy_credentials[:rabbit_uuid]
    end

    def bush_generator(number)
        positions = number.times.map do |i|
            {top: rand(10..90), left: rand(10..90), key: SecureRandom.hex(16), uuid: SecureRandom.hex(16), is_rabbit_hide: false}
        end
        scotty_hide = rand(0...number)
        scotty_credentials = @session.rabbit_credentials("Scotty")
        scotty_key = scotty_credentials[:rabbit_key]
        scotty_uuid = scotty_credentials[:rabbit_uuid]
        positions[scotty_hide][:is_rabbit_hide] = true
        positions[scotty_hide][:key] = scotty_key
        positions[scotty_hide][:uuid] = scotty_uuid
        positions
    end
end
