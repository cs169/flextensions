namespace :v1 do
  get :ping, to: 'ping#ping'
  get :swagger, to: 'swagger#read'
  resources :assignments, only: [:index, :create, :destroy]
end
