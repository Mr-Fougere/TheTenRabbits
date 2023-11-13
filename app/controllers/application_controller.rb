class ApplicationController < ActionController::Base

    before_action :set_session, only: [:home, :continue_session]

    def home
        debbie_credentials = @session.rabbit_credentials("Debbie")
        @debbie_key = debbie_credentials[:rabbit_key]
        @debbie_uuid = debbie_credentials[:rabbit_uuid]
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

    def bush_generator(number)
        positions = number.times.map do |i|
            {top: rand(10..90), left: rand(10..90), key: SecureRandom.hex(16), uuid: SecureRandom.hex(16), is_rabbit_hide: false}
        end
        steevie_hide = rand(0...number)
        steevie_credentials = @session.rabbit_credentials("Steevie")
        steevie_key = steevie_credentials[:rabbit_key]
        steevie_uuid = steevie_credentials[:rabbit_uuid]
        positions[steevie_hide][:is_rabbit_hide] = true
        positions[steevie_hide][:key] = steevie_key
        positions[steevie_hide][:uuid] = steevie_uuid
        positions
    end
end
