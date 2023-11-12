class ApplicationController < ActionController::Base

    before_action :set_session, only: [:home, :continue_session]

    def home
        debbie_credentials = @session.rabbit_credentials("Debbie")
        @debbie_key = debbie_credentials[:rabbit_key]
        @debbie_uuid = debbie_credentials[:rabbit_uuid]

    end

    def start_session
        session = Session.create
        cookies[:uuid] = session.uuid
        redirect_to root_path
    end

    def continue_session

    end

    def set_session
        @session = Session.find_by(uuid: cookies[:uuid])
    end
end
