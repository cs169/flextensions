Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Add rack_session_access routes for testing
  # if Rails.env.test?
  #   mount RackSessionAccess::Engine => '/rack_session'
  # end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'status/health_check', to: 'status#health_check'
  get 'status/version', to: 'status#version'

  root "home#index"
  get '/courses', to: 'courses#index', as: 'courses'
  get '/courses/new', to: 'courses#new', as: :new_course
  get '/courses/:id', to: 'courses#show', as: :course
  get '/courses/:id/edit', to: 'courses#edit', as: :course_settings

  resources :courses do
    member do
      post :sync_assignments
      post :sync_enrollments
      get :enrollments
      delete :delete
    end
    resources :extensions, only: [:create]
    resources :requests do
      member do
        post :approve
        post :reject
        post :cancel
      end
      collection do
        post :create_for_student
        get :export, defaults: { format: :csv }
      end
    end
    resource :form_setting, only: [:edit, :update]
  end
  post 'course_settings/update'

  resources :assignments do
    member do
      patch :toggle_enabled
    end
  end

  # Authentication routes
  match "/auth/:provider/callback", to: "session#omniauth_callback", as: :omniauth_callback, via: [:get, :post]
  get "/auth/failure", to: "session#omniauth_failure", as: "omniauth_failure"
  get '/logout', to: 'session#logout', as: :logout

  namespace :api do
    draw('api/v1')
  end

  # This is protected by `require_admin` via blazer.yml
  mount Blazer::Engine, at: "admin/blazer"
end
