Rails.application.routes.draw do
  resources :posts
  resources :users
  resources :comments, only: [:index, :create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "posts#index"

  get '/login', to: 'sessions#index'
  post '/login', to: 'login#login'
  get 'logout', to: 'login#logout'
end
