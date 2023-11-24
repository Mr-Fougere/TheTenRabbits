Rails.application.routes.draw do
  root 'application#home'

  post '/', to: 'api#api_help', as: 'api_help'
  post '/api', to: 'api#api_request', as: 'api_request'

  post '/introduction', to: 'sessions#introduction', as: 'introduction'
  post '/continue', to: 'sessions#continue', as: 'continue'

  post '/seek_rabbit', to: 'sessions#seek_rabbit', as: 'seek_rabbit'
  post '/switch_language', to: 'sessions#switch_language', as: 'switch_language'
  post '/switch_colored_hint', to: 'sessions#switch_colored_hint', as: 'switch_colored_hint'
  post '/vote_rabbit', to: 'sessions#vote_rabbit', as: 'vote_rabbit'

  post '/current_speech', to: 'speeches#current_speech', as: 'current_rabbit_speech'
  post '/answer_speech', to: 'speeches#answer_speech', as: 'answer_rabbit_speech'
  post '/carrot_recognizer', to: 'application#carrot_recognizer', as: 'carrot_recognizer'

  mount ActionCable.server => '/cable'
  get '/cv', to: 'application#display_cv', as: 'display_cv'
  get '*path', to: 'application#wrong_path', via: :all

end
