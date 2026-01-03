Rails.application.routes.draw do
  root "lists#index"

  get "/about", to: "pages#about"

  resource :session, only: [ :new, :create, :destroy ]
  resources :users, only: [ :new, :create ]

  resources :lists do
    member do
      get :sharing
    end

    resources :items, only: [ :create, :show, :edit, :update, :destroy ] do
      collection { delete :clear_completed }
    end

    resources :memberships, controller: "list_memberships", only: [ :create, :update, :destroy ]
  end

  namespace :admin do
    root "dashboard#index"

    resources :users, only: [ :index, :show ] do
      member do
        post :set_password
        post :disable
        post :enable
        post :make_admin
        post :remove_admin
      end
    end

    resources :signup_tokens, only: [ :index, :new, :create ] do
      member do
        post :revoke
      end
    end
  end
end
