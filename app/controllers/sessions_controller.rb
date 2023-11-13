class SessionsController < ApplicationController

    before_action :set_session, only: [:seek_rabbit,:safe_route]
    skip_before_action :verify_authenticity_token


    def seek_rabbit
        return unless @session
        return unless params[:rabbit_key].present? && params[:rabbit_uuid].present?
        
        session_rabbit = @session.session_rabbits.hidden.find_by(key: params[:rabbit_key], uuid: params[:rabbit_uuid])
        return unless session_rabbit

        session_rabbit.waiting_found_animation!
    end

    def switch_mode
    
    end

    
    private

    def set_session
        @session = Session.find_by(uuid: params[:session_uuid]) || Session.find_by(uuid: cookies[:uuid])
    end

end