class ApplicationController < ActionController::Base

    before_action :set_session, only: [:seek_rabbit,:home, :continue_session]

    def home
    end

    def start_session
        session = Session.create!
        session[:uuid] = session.uuid
    end

    def continue_session
    end

    def seek_rabbit
        
    end

    def set_session
        @session = Session.find(session[:uuid]) if session[:uuid]
    end
end
