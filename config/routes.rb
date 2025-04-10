Rails.application.routes.draw do
  # Add rack_session_access routes for testing
  # if Rails.env.test?
  #   mount RackSessionAccess::Engine => '/rack_session'
  # end
  
  get 'courses/index'
  get 'bcourses/index'
  get 'bcourses', to: 'bcourses#index'
  get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
  get '/courses', to: 'courses#index', as: 'courses'
  get '/courses/new', to: 'courses#new', as: :new_course
  get '/courses/:id', to: 'courses#show', as: :course
  get '/courses/:id/edit', to: 'courses#edit', as: :course_settings
  get '/courses/:id/requests', to: 'courses#requests', as: :course_requests
  get '/courses/:id/form', to: 'courses#form', as: :course_extension_form
  
  # Add the delete_all route for courses
  resources :courses do
    member do
      post :sync_assignments
    end
    collection do
      delete :delete_all
    end
  end

  #Authentication routes
  get '/login/' => 'login#canvas', :as => :login 
  get '/login/canvas', to: 'login#canvas', as: :bcourses_login
  match '/auth/canvas/callback', to: 'session#create', as: :canvas_callback, via: [:get, :post]
  get '/logout' => 'login#logout', :as => :logout

  namespace :api do
    draw('api/v1')
  end
end
