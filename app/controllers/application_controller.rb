class ApplicationController < ActionController::Base

    include RabbitGenerator

    before_action :set_session, only: [:home,:wrong_path]
    before_action :set_locale,  only: [:home,:wrong_path]

    def home
        return unless @session.present?

        check_github_visit
        check_security_visit

        setup_rabbit_credentials
        @bushes = bush_generator(7)
    end

    def wrong_path
        render "wrong_path", locals: {session_rabbit: @session.session_rabbit_named("Sergie")}
    end

    def check_security_visit
        return unless request.referer.present?
        return unless URI.parse(request.referer).path

        @session.found_rabbit("Sergie")
    end

    def check_github_visit
        return unless request.referer.present?
        return unless request.referer.include?("https://github.com/Mr-Fougere/TheTenRabbits/blob/ginny/ginny.md")
        
        @session.found_rabbit("Ginny")
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
