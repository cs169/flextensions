Rails.application.routes.draw do
  get 'offering/index'
  get 'bcourses/index'
  get 'bcourses', to: 'bcourses#index'
  get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
  get '/offerings', to: 'offerings#index', as: 'offerings'
  
  #Authentication routes
  get '/login/' => 'login#index', :as => :login 
  get '/login/canvas', to: 'login#canvas', as: :bcourses_login
  match '/auth/canvas/callback', to: 'session#create', as: :canvas_callback, via: [:get, :post]
  get '/logout' => 'login#logout', :as => :logout

  namespace :api do
    draw('api/v1')
  end
end
