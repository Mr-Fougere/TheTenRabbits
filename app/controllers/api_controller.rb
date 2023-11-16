class ApiController < ActionController::Base

   skip_before_action :verify_authenticity_token, only: [:api_request, :api_help]

    def api_request
        api_key = request.headers["Authorization"] || params[:key]
        return render json: """You found an little house locked you don't have the KEY
           _-'_'-_
        _-' _____ '-_
     _-' ___________ '-_
      |___|||||||||___|
      |___|||||||||___|
      |___|||||||o|___|
      |___|||||||||___|
      |___|||||||||___|
      |___|||||||||___|""" , status: 423 unless api_key

        @session = Session.find_by(api_key: api_key)
        return render json: """You try to open the little house but it's not seem the good key,
        _-'_'-_
     _-' _____ '-_
  _-' ___________ '-_
   |___|||||||||___|
   |___|||||||||___|
   |___|||||||o|___|
   |___|||||||||___|
   |___|||||||||___|
   |___|||||||||___|""", status: 401 unless @session.present?
          
        session_appie = @session.session_rabbit_named("Appie")
        if session_appie.hidden?
            @session.found_rabbit("Appie")
            render json: """Oh you found me! How do you got my secret key?
                _-'_'-_
             _-' _____ '-_
          _-' ___________ '-_
           |__||       |___|
           |__||       |___|
           |__||{\\__/} |___|
           |__q|( •.•) |___|
           |__||/ >< \\ |___|
           |__||_______|___|
           """
        else
            render json: """The little house is empty ...
            _-'_'-_
         _-' _____ '-_
      _-' ___________ '-_
       |__||       |___|
       |__||       |___|
       |__||       |___|
       |__q|       |___|
       |__||       |___|
       |__||_______|___|
       """, status: 410
        end
      
    end

    def api_help
        render json: I18n.t("api_help")
    end
end