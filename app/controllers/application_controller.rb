class ApplicationController < ActionController::Base

    before_action :set_session, only: [:seek_rabbit,:home, :continue_session]

    def home
    end

    def start_session
        session = Session.create
        cookies[:uuid] = session.uuid
        redirect_to root_path
    end

    def continue_session
        
    end

    def seek_rabbit
        
    end

    def set_session
        @session = Session.find_by(uuid: cookies[:uuid])
    end
end
