    class SessionsController < ApplicationController
        include ActionCable::Channel::Broadcasting

        before_action :set_session, only: [:seek_rabbit,:safe_route, :switch_mode]
        skip_before_action :verify_authenticity_token


        def seek_rabbit
            return unless @session
            return unless params[:rabbit_key].present? && params[:rabbit_uuid].present?
            
            session_rabbit = @session.session_rabbits.hidden.find_by(key: params[:rabbit_key], uuid: params[:rabbit_uuid])
            return unless session_rabbit

            session_rabbit.waiting_found_animation!
        end

        def switch_mode
            return unless @session.present? && params[:mode].present?

            if params[:mode] == "dark"
                credentials = @session.rabbits_credentials(["Timmy"])
                Turbo::StreamsChannel.broadcast_prepend_to "session-#{@session.uuid}", target:"home-#{@session.uuid}" , partial: "elements/timmy", locals: { session: @session , credentials: credentials }
            else
                Turbo::StreamsChannel.broadcast_remove_to "session-#{@session.uuid}", target: "timmy-#{@session.uuid}"
            end
        end

        private

        def set_session
            @session = Session.find_by(uuid: params[:session_uuid] || cookies[:uuid])
        end

    end