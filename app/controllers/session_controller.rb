class SessionController < ApplicationController
  def create
    if params[:error].present? || params[:code].blank?
      redirect_to root_path, alert: 'Authentication failed. Please try again.'
      return
    end
    canvas_code = params[:code]

    token = get_access_token(canvas_code)
    # Fetch user profile from Canvas API using the token
    response = Faraday.get("#{ENV.fetch('CANVAS_URL', nil)}/api/v1/users/self?") do |req|
      req.headers['Authorization'] = "Bearer #{token}"
    end

    if response.success?
      user_data = JSON.parse(response.body)
      Rails.logger.debug(user_data)
      Rails.logger.info "User Data: #{user_data}"
      find_or_create_user(user_data, token)
      redirect_to offerings_path, notice: 'Logged in!'
    else
      redirect_to root_path, alert: 'Authentication failed. Invalid token.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out!'
  end

  private

  def get_access_token(code)
    client = OAuth2::Client.new(
      ENV.fetch('CANVAS_CLIENT_ID', nil),
      ENV.fetch('APP_KEY', nil),
      site: ENV.fetch('CANVAS_URL', nil),
      token_url: '/login/oauth2/token'
    )
    token = client.auth_code.get_token(code, redirect_uri: :canvas_callback)
    token.token
  end

  def find_or_create_user(user_data, token)
    # Find or create user in database
    Rails.logger.info "User token: #{token}"

    user = nil
    if User.exists?(email: user_data['primary_email'])
      user = User.find_by(email: user_data['primary_email'])
      user.update(canvas_token: token)
    elsif User.exists?(canvas_uid: user_data['id'])
      user = User.find_by(canvas_uid: user_data['id'])
      user.update(canvas_token: token)
    else
      user = User.find_or_initialize_by(canvas_uid: user_data['id'])
      user.assign_attributes(
        email: user_data['email'],
        name: user_data['name'],
        canvas_token: token # Store the token to use for API requests
        # canvas_token_expires_at: Time.current + 1.hours
      )
      # session[:user_info] = user_data
      user.save!
    end
    # Store user ID in session for authentication
    session[:username] = user.name
    session[:user_id] = user.id
  end
end
