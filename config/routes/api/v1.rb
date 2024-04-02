namespace :v1 do
  get :ping, to: 'ping#ping'
  get :swagger, to: 'swagger#read'
  # resources :courses, only: [:create, :destroy, :index] do
  #   resources :lmss, only: [:create, :destroy, :index] do
  #     resources :assignments, only: [:create, :destroy, :index] do
  #       resources :extensions, only: [:create, :index]
  #     end
  #   end
  # end

#clearer options
  get '/courses/:course_id/lmss/:lms_name/assignments/:assignment_id/extensions', to: 'extensions#index'
  post '/courses/:course_id/lmss/:lms_name/assignments/:assignment_id/extensions', to: 'extensions#create'
end