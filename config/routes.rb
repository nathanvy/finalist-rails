Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  #public routes (no auth, for legacy reasons)
  scope '/pubapi' do
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
  end

  #protected/authenticated routes
  # a lot of these defy Rails convention because legacy design
  scope '/api' do
    get '/listview', to: 'lists#index' #index is the convention for "list all of <thing>"
    get '/lists/:id', to: 'lists#show' #show is the convention for "show single <thing> by ID
  end
  resources :users, only: [:show]
  #... etc
end

