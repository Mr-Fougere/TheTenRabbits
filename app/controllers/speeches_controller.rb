class SpeechesController < ActionController::Base

    before_action :set_session
    before_action :set_session_rabbit
    before_action :set_locale
    skip_before_action :verify_authenticity_token

    def current_speech
        return unless @session_rabbit.present?
        return unless @session.present?

        @session_rabbit.broadcast_current_speech
    end

    def answer_speech
        return unless @session.present? && @session_rabbit.present? && params[:answer].present?

        @session_rabbit.broadcast_next_speech(params[:answer])
    end

    private 

    def set_session
        @session = Session.find_by(uuid: params[:session_uuid] || cookies[:uuid])
    end

    def set_session_rabbit
        @session_rabbit = @session.session_rabbits.find_by(uuid: params[:rabbit_uuid])
    end

    def set_locale
        I18n.locale = @session&.language || I18n.default_locale
    end


end