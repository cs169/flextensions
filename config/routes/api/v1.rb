namespace :v1 do
  get :ping, to: 'ping#ping'
  get :swagger, to: 'swagger#read'
  resources :users, only: [:create, :destroy, :index]
  resources :courses, only: [:create, :destroy, :index] do
    put 'add_user/:user_id', action: :add_user
    resources :lmss, only: [:create, :destroy, :index] do
      resources :assignments, only: [:create, :destroy, :index] do
        resources :extensions, only: [:create, :destroy, :index]
      end
    end
  end
end
