Rails.application.routes.draw do
  resources :users
  resources :comments, only: [:index, :create]
  resources :jobs, only: [:create, :show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :posts do
    collection do
      get :import
    end
  end

  root to: "posts#index"

  get '/login', to: 'sessions#index'
  post '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'
end
