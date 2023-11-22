class ApplicationController < ActionController::Base

    include RabbitGenerator

    before_action :set_session, only: [:home,:wrong_path, :carrot_recognizer]
    before_action :set_locale,  only: [:home,:wrong_path, :carrot_recognizer]

    skip_before_action :verify_authenticity_token, only: [:carrot_recognizer]

    def home
        return unless @session.present?

        check_security_visit
        @bushes = bush_generator(7)
        @api_key = @session.api_key
    end

    def wrong_path
        @sergie = @session.session_rabbit_named("Sergie")
        render "wrong_path"
    end

    def check_security_visit
        return unless request.referer.present?
        return unless URI.parse(request.referer).path

        @session.found_rabbit("Sergie")
    end

    def carrot_recognizer
        return unless params[:file].present? && @session.present?

        image_path = params[:file].tempfile.path
        return unless image_path.present?
        
        recognizer = ImageRecognizer::CarrotRecognizer.new(image_path)
        recognizer.perform
        @session.found_rabbit("Ginny") if recognizer.verdict
    end

    private 
    
    def set_session
        @session = Session.find_by(uuid: cookies[:uuid] || params[:session_uuid] )
        return if @session.present?

        @session = Session.create
        cookies[:uuid] = @session.uuid
    end

    def set_locale
        I18n.locale = @session&.language || I18n.default_locale
    end

end
