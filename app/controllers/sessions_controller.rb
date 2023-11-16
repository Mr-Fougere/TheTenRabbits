    class SessionsController < ActionController::Base
        include ActionCable::Channel::Broadcasting
        include RabbitGenerator

        before_action :set_session
        skip_before_action :verify_authenticity_token

        def introduction 
            session_sparky =  @session.session_rabbits.find_by(rabbit: Rabbit.find_by(name: "Sparky"))
            session_sparky.found!
            broadcast_rabbit_found
        end

        def continue
            broadcast_rabbit_found
        end

        def found_rabbit
            return unless @session.present? && params[:key]
            
            waiting_rabbits = @session.session_rabbits.waiting_found_animation
            waiting_rabbit = waiting_rabbits.find_by(key: params[:key])
            return unless waiting_rabbit
            
            waiting_rabbit.found!
            broadcast_rabbit_found
        end

        def seek_rabbit
            return unless @session
            return unless params[:rabbit_key].present? && params[:rabbit_uuid].present?
            
            session_rabbit = @session.session_rabbits.hidden.find_by(key: params[:rabbit_key], uuid: params[:rabbit_uuid])
            return unless session_rabbit

            session_rabbit.waiting_found_animation!
            broadcast_rabbit_found
        end

        def switch_language
            return unless @session.present? && params[:language].present?

            update_session_ui if @session.update(language: params[:language])
        end

        def update_session_status
            return
            return unless @session.present? && params[:new_status].present?

            @session.update(status: params[:new_status])
            broadcast_rabbit_found if params[:new_status] == "connected"
        end

        private

        def broadcast_rabbit_found
            waiting_rabbit = @session.session_rabbits.waiting_found_animation.last   
            Turbo::StreamsChannel.broadcast_replace_to "session-#{@session.uuid}", target: "rabbit-modal-#{@session.uuid}", partial: "elements/rabbit_modal", locals: { session_rabbit: waiting_rabbit, session: @session }
        end

        def update_session_ui
            I18n.locale = @session.language
            larry = @session.session_rabbit_named("Larry")
            return unless larry
            return unless larry.hidden?
            return larry.hide! if @session.language == "rbt"

            larry.remove_rabbit_from_hide! 
        end

        def set_session
            @session = Session.find_by(uuid: params[:session_uuid] || cookies[:uuid])
        end

    end