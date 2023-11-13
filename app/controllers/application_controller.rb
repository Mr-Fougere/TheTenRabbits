class ApplicationController < ActionController::Base

    before_action :set_session, only: [:home, :continue_session, :api_request]
    APPIE_FAVORITE_PIE = "bourdaloue"

    def home
        return unless @session

        check_github_visit
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

    def safe_route
        redirect_to root_path

        return unless request.referer.present?
        return if request.referer.include?("https")
        
        @session.found_rabbit("Sergie")
    end

    def check_github_visit
        return unless request.referer.present?
        return unless request.referer === "https://github.com/Mr-Fougere/TheTenRabbits/blob/ginny/ginny.md"
        
        @session.found_rabbit("Ginny")
    end

    def api_request
        return render json: "I can't identify you with your Session ID" unless params[:session_id]

        @session = Session.find_by(uuid: params[:session_id] )
        return render json: "I dont know you" unless @session.present?
        
        desert =  params[:pie]
        return render json: "Don't interrup me if you don't have a pie !" unless desert

        return render json: "Burk I don't like this type of pie" unless desert == APPIE_FAVORITE_PIE

        @session.found_rabbit("Appie")
        render json: "\{\\__/\} \n( •.•)\n / >< \\ \nOh! My favorite pie! Thank you so much I come with you" 
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

    
    def set_session
        @session = Session.find_by(uuid: cookies[:uuid] )
    end

end
