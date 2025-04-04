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
      req.headers['Authorization'] = "Bearer #{token.token}"
    end

    if response.success?
      user_data = JSON.parse(response.body)
      #   Rails.logger.debug(user_data)
      #   Rails.logger.info "User Data: #{user_data}"
      find_or_create_user(user_data, token)
      redirect_to courses_path, notice: 'Logged in!'
    else
      redirect_to root_path, alert: 'Authentication failed. Invalid token.'
      # Looking into the status code in response.status
    end
  end

  def destroy
    redirect_to :logout, notice: 'Logged out!'
  end

  private

  # Everytime someone tries to log in, they have to get a new token.
  # There is no way we reuse the token for login since when a user clicks
  # the login button, they are redirected to the Canvas login page immediately.
  # If you are looking for logic of refresh token,
  def get_access_token(code)
    client = OAuth2::Client.new(
      ENV.fetch('CANVAS_CLIENT_ID', nil),
      ENV.fetch('APP_KEY', nil),
      site: ENV.fetch('CANVAS_URL', nil),
      token_url: '/login/oauth2/token'
    )
    client.auth_code.get_token(code, redirect_uri: :canvas_callback)
  end

  def find_or_create_user(user_data, full_token)
    # Find or create user in database
    token = full_token.token
    user = nil
    if User.exists?(email: user_data['primary_email'])
      user = User.find_by(email: user_data['primary_email'])
      user.canvas_uid = user_data['id']
    elsif User.exists?(canvas_uid: user_data['id'])
      user = User.find_by(canvas_uid: user_data['id'])
      user.email = user_data['email']
    else
      user = User.find_or_initialize_by(canvas_uid: user_data['id'])
      user.assign_attributes(
        email: user_data['email'],
        name: user_data['name']
      )
    end
    user.canvas_token = token
    user.save!

    # Store user ID in session for authentication
    session[:username] = user.name
    session[:user_id] = user.canvas_uid
  end

  def update_user_credential(user, token)
    # update user's lms credentials.
    if user.lms_credentials.any?
      user.lms_credentials.first.update(
        token: token.token,
        refresh_token: token.refresh_token,
        expire_time: Time.zone.at(token.expires_at)
      )
    else
      user.lms_credentials.create!(
        lms_name: 'canvas',
        token: token,
        refresh_token: full_token.refresh_token,
        expire_time: Time.zone.at(full_token.expires_at)
      )
    end
  end
  # serialize user data in activeRecord/activeModels (rails serialize)
end
