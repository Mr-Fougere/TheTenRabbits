Rails.application.routes.draw do
 root "application#home"
 post "/start_session", to: "application#start_session", as: "start_session"
 post "/continue_session/:id", to: "application#continue_session", as: "continue_session"

end
