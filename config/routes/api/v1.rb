namespace :v1 do
  get :ping, to: 'ping#ping'
  get :swagger, to: 'swagger#read'
  resources :courses, only: [:create, :destroy, :index] do
    resources :lmss, only: [:create, :destroy, :index] do
      resources :assignments, only: [:index, :create, :destroy]
    end
  end
end
