namespace :v1 do
  get :ping, to: 'ping#ping'
  get :swagger, to: 'swagger#read'
  resources :courses, only: [:create, :destroy, :index] do
    resources :lmss, only: [:create, :destroy, :index] do
      resources :assignments, only: [:create, :destroy, :index] do
        resources :extensions, only: [:create, :destroy, :index]
      end
    end
  end
end