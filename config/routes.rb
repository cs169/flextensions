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
  namespace :api do
    draw('api/v1')
  end
end
