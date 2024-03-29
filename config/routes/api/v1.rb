namespace :v1 do
  get :ping, to: 'ping#ping'
  get :swagger, to: 'swagger#read'
  resources :users, only: [:index, :create, :destroy]
end
