class ApplicationController < ActionController::Base

    include RabbitGenerator

    APPIE_FAVORITE_PIE = "bourdaloue"

    before_action :set_session, only: [:home, :api_request]
    before_action :set_locale,  only: [:home,:api_request]

    def home
        @session.initialized!
        return unless @session.present?

        check_github_visit
        setup_rabbit_credentials
        @bushes = bush_generator(7)
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
    
    def set_session
        @session = Session.find_by(uuid: cookies[:uuid] )
        return if @session.present?

        @session = Session.create
        cookies[:uuid] = @session.uuid
    end

    def set_locale
        I18n.locale = @session&.language || I18n.default_locale
    end

end
