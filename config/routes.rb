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
  
  # Add the delete_all route for courses
  resources :courses do
    member do
      post :sync_assignments
      post :sync_enrollments
      get :enrollments
    end
    collection do
      delete :delete_all
    end
    resources :extensions, only: [:create]
    resources :requests do
      collection do
        get :history
      end
      member do
        post :approve
        post :reject
      end
    end
    resource :form_setting, only: [:edit, :update]
    resource :course_setting, only: [:update]
  end

  resources :assignments do
    member do
      patch :toggle_enabled
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
