class SessionController < ApplicationController
    
    def create
      client = OAuth2::Client.new(
        CANVAS_CLIENT_ID,
        CANVAS_CLIENT_SECRET,
        site: CANVAS_URL,
        token_url: '/login/oauth2/token'
      )
  
      # Exchange authorization code for an access token
      token = client.auth_code.get_token(params[:code], redirect_uri: session_canvas_callback_url)
  
      # Fetch user profile from Canvas
      response = token.get("#{CANVAS_URL}/api/v1/users/self")
      user_data = JSON.parse(response.body)
  
      # Find or create user in the database
      user = User.find_or_initialize_by(canvas_uid: user_data['id'])
      user.assign_attributes(
        email: user_data['primary_email'],  # Adjust depending on Canvas API response
        name: user_data['name'],
        canvas_token: token.token,
        canvas_refresh_token: token.refresh_token,
        canvas_token_expires_at: Time.current + token.expires_in.seconds
      )
      user.save!
  
      # Store user ID in session for authentication
      session[:user_id] = user.id
  
      redirect_to root_path, notice: "Logged in successfully!"
    rescue OAuth2::Error => e
      Rails.logger.error "Canvas OAuth Error: #{e.message}"
      redirect_to auth_failure_path, alert: "Authentication failed. Please try again."
    end
  
    def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: "Logged out!"
    end
  
    def failure
      redirect_to root_path, alert: "Canvas authentication failed."
    end
  end
  