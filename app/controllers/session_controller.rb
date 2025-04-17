class SessionController < ApplicationController
  include TokenRefreshable

  def create
    if params[:error].present? || params[:code].blank?
      redirect_to root_path, alert: 'Authentication failed. Please try again.'
      return
    end

    canvas_code = params[:code]
    token = get_access_token(canvas_code)

    response = Faraday.get("#{ENV.fetch('CANVAS_URL', nil)}/api/v1/users/self?") do |req|
      req.headers['Authorization'] = "Bearer #{token.token}"
    end

    if response.success?
      user_data = JSON.parse(response.body)
      find_or_create_user(user_data, token)
      redirect_to courses_path, notice: 'Logged in!'
    else
      redirect_to root_path, alert: 'Authentication failed. Invalid token.'
    end
  end

  def destroy
    redirect_to :logout, notice: 'Logged out!'
  end

  private

  def get_access_token(code)
    create_oauth_client.auth_code.get_token(code, redirect_uri: :canvas_callback)
  end

  def find_or_create_user(user_data, full_token)
    user = User.find_or_initialize_by(canvas_uid: user_data['id'])
    user.assign_attributes(
      email: user_data['email'],
      name: user_data['name']
    )
    user.save!
    update_user_credential(user, full_token)

    session[:username] = user.name
    session[:user_id] = user.canvas_uid
  end

  def update_user_credential(user, token)
    if user.lms_credentials.any?
      user.lms_credentials.first.update(
        token: token.token,
        refresh_token: token.refresh_token,
        expire_time: Time.zone.at(token.expires_at)
      )
    else
      user.lms_credentials.create!(
        lms_name: 'canvas',
        token: token.token,
        refresh_token: token.refresh_token,
        expire_time: Time.zone.at(token.expires_at)
      )
    end
  end
end
