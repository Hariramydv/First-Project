Rails.application.routes.draw do
   root 'properties#index'
   get 'serch',to: "properties#profile"
   get 'search',to: "properties#index"

  resources :properties do
    get :approve_listing, on: :member
    collection do
      get :pending_listings, action: :index
      get :unapproved_listings, action: :index
      get :current_listings, action: :index
      get :profile
    end
  end
  
  resources :users, only: :index do
    collection do
      get :main
      get :home
      get :about
      get :contact
    end
  end
  
  devise_for :users, controllers: { sessions: 'sessions' }

end
