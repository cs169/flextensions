class SessionsController < ApplicationController
    def create
      auth = request.env['omniauth.auth']
      # Here you would typically handle user creation or session setup
      user = User.from_omniauth(auth)
      session[:user_id] = user.id
      redirect_to root_path, notice: "Signed in!"
    end
  
    def failure
      # handle failure
      redirect_to root_path, alert: "Authentication failed, please try again."
    end
  end
  