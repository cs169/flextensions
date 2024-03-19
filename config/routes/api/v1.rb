namespace :v1 do
  get :ping, to: 'ping#ping'
  get :swagger, to: 'swagger#read'
  resources :courses, only: [:create, :destroy, :index] do
    resources :lms, only: [:create, :destroy, :index]
  end
end
