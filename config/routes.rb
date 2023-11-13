Rails.application.routes.draw do
    root "application#home"

    post "/start_session", to: "application#start_session", as: "start_session"
    post "/continue_session/:id", to: "application#continue_session", as: "continue_session"
    post '/seek_rabbit', to: "sessions#seek_rabbit", as: "seek_rabbit"
    get '/safe_route', to: "sessions#safe_route", as: "safe_route"

    post '/switch_mode', to: "sessions#switch_mode", as: "switch_mode"
    post '/api', to: "sessions#api_request"
    mount ActionCable.server => '/cable'
end
