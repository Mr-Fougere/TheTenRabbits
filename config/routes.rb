Rails.application.routes.draw do
    root "application#home"


    post "/introduction", to: "sessions#introduction", as: "introduction"
    post "/continue", to: "sessions#continue", as: "continue"

    post '/api', to: "application#api_request", as: "api_request"    
    get '/safe_route', to: "application#safe_route", as: "safe_route"
    post '/talk_larry', to: "sessions#talk_larry", as: "talk_larry"

    post '/seek_rabbit', to: "sessions#seek_rabbit", as: "seek_rabbit"
    post '/switch_language', to: "sessions#switch_language", as: "switch_language"
    post '/update_session_status', to: "sessions#update_session_status", as: "update_session_status"
    post '/found_rabbit', to: "sessions#found_rabbit", as: "found_rabbit"
    
    post '/current_speech', to: "speeches#current_speech", as: "current_rabbit_speech"
    post '/answer_speech', to: "speeches#answer_speech", as: "answer_rabbit_speech"

    mount ActionCable.server => '/cable'
end
