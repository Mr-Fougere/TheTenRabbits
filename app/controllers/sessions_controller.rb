    class SessionsController < ActionController::Base
        include ActionCable::Channel::Broadcasting
        include RabbitGenerator

        before_action :set_session
        skip_before_action :verify_authenticity_token

        VALID_ANSWER_LARRY = ["044104010430","441401430","042104320410","421432410"]

        def introduction 
            session_sparky =  @session.session_rabbits.find_by(rabbit: Rabbit.find_by(name: "Sparky"))
            session_sparky.found!
        end

        def continue
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

        def switch_mode
            return unless @session.present? && params[:mode].present?

            if params[:mode] == "dark"
                credentials = @session.rabbits_credentials(["Timmy"])
                Turbo::StreamsChannel.broadcast_prepend_to "session-#{@session.uuid}", target:"home-#{@session.uuid}" , partial: "elements/timmy", locals: { session: @session , credentials: credentials }
            else
                Turbo::StreamsChannel.broadcast_remove_to "session-#{@session.uuid}", target: "timmy-#{@session.uuid}"
            end
        end

        def switch_language
            return unless @session.present? && params[:language].present?

            @session.update(language: params[:language])
            update_session_ui
        end

        def talk_larry
            return unless @session.present? && params[:message].present?
            
            if VALID_ANSWER_LARRY.include?(params[:message])
                @session.seek_rabbit("Larry")
            end
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
            setup_rabbit_credentials
            @bushes = bush_generator(7)
            Turbo::StreamsChannel.broadcast_replace_to "session-#{@session.uuid}", target: "home-#{@session.uuid}", partial: "application/home", locals: { credentials: @credentials, bushes: @bushes, session: @session }
        end

        def set_session
            @session = Session.find_by(uuid: params[:session_uuid] || cookies[:uuid])
        end

    end