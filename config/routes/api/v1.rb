namespace :v1 do
  get :ping, to: 'ping#ping'
  get :swagger, to: 'swagger#read'
  resources :users, only: [:create, :destroy, :index]
  resources :courses, only: [:create, :destroy, :index] do
    put 'add_user/:user_id', action: :add_user
  end
end
