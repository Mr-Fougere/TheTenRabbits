Rails.application.routes.draw do
    root "application#home"

    get '/safe_route', to: "sessions#safe_route", as: "safe_route"

    post '/api', to: "sessions#api_request", as: "api_request"
    post "/introduction", to: "sessions#introduction", as: "introduction"
    post "/continue", to: "sessions#continue", as: "continue"
    post '/seek_rabbit', to: "sessions#seek_rabbit", as: "seek_rabbit"
    post '/switch_language', to: "sessions#switch_language", as: "switch_language"
    post '/talk_larry', to: "sessions#talk_larry", as: "talk_larry"
    post '/switch_mode', to: "sessions#switch_mode", as: "switch_mode"
    post '/update_session_status', to: "sessions#update_session_status", as: "update_session_status"
    post '/found_rabbit', to: "sessions#found_rabbit", as: "found_rabbit"
    
    mount ActionCable.server => '/cable'
end
