class SpeechesController < ActionController::Base

    before_action :set_session
    before_action :set_session_rabbit

    def current_speech

    end

    def speech_answer
        return unless @session_rabbit.speech_status == "waiting_answer"
        return unless @session.present? && @session_rabbit.present? && params[:answer].present?

        @session_rabbit.next_speech(params[:answer])
    end

    private 

    def set_session
        @session = Session.find_by(uuid: params[:session_uuid] || cookies[:uuid])
    end

    def set_session_rabbit
       @session.session_rabbit.found.find_by(uuid: params[:rabbit_uuid])
    end

end