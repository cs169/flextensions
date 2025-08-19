class SessionController < ApplicationController
  include TokenRefreshable

  ## Login work flow explained here
  # Currently the login only supports third-party authentication with Canvas.
  # But the structure to support multiple login methods is largely in place.
  # The omniauth_callback function now does nothing more than calling the
  # create function used for Canvas login. It's just a placeholder.
  #
  # ==================IMPORTANT Canvas Login Explaination========================
  # If you try to use request.env['omniauth.auth'] inside this function,
  # it will return nil. This is because I made omniauth request to Canvas manually
  # and post the Canvas code directly to SessionController#create. Hence, Omniauth never
  # runs. If you want to use omniauth for Canvas login instead, replace the Login button
  # with something like erb<br><%= link_to 'Login with Canvas', '/auth/canvas' %>.
  #
  # =======================How to add another login method========================
  # If you want to add another login method, follow the steps below:
  # 1. Add the new provider to the omniauth.rb file.
  # 2. To avoid change too much existing code, I would suggest to add
  #    more login buttons to the login page (like "logins with Google") or
  #    smth like that. Each button should support one login method. The existing
  #    login button should be used for Canvas login.
  # 3. For each new login button, make a POST request to auth/:provider/.
  #    See BJC-Teacher-Tracker/app/views/sessions/new.html.erb for an example.
  # 4. Currently all login logics are handled in create function. It only handles
  #    Canvas login. You can add more login methods to this function and create
  #    user objects in the same way as Canvas login. You can also move part of
  #    the logic from "create" to "omniauth_callback".

  def logout
    reset_session
    redirect_to root_path
  end

  def omniauth_callback
    if params[:error].present?
      redirect_to root_path, alert: 'Authentication failed. Please try again.'
      return
    end

    auth = request.env['omniauth.auth']
    unless auth
      redirect_to root_path, alert: 'Authentication failed. No credentials received.'
      return
    end

    user_data = {
      'id' => auth.uid,
      'name' => auth.info.name,
      'primary_email' => auth.info.email,
      'email' => auth.info.email
    }
    creds = auth.credentials # an OmniAuth::AuthHash
    access_token = OAuth2::AccessToken.new(
      OAuth2::Client.new('', ''), # client never used – stub
      creds.token,
      refresh_token: creds.refresh_token,
      expires_at: creds.expires_at
    )

    # Persist / update the user just like `create`
    find_or_create_user(user_data, access_token)

    redirect_to courses_path, notice: "Logged in! Welcome, #{user_data['name']}!"
  rescue StandardError => e
    Rails.logger.error("OmniAuth callback error: #{e.message}")
    redirect_to root_path, alert: 'Authentication failed. Invalid credentials.'
  end

  def omniauth_failure
    redirect_to root_path, alert: 'Authentication failed. Please try again.'
  end

  def destroy
    redirect_to :logout, notice: 'Logged out!'
  end

  private

  # TODO: Refactor.
  def find_or_create_user(user_data, auth_token)
    auth_token.token
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
    user.save!
    update_user_credential(user, auth_token)

    # Store user ID in session for authentication
    session[:username] = user.name
    session[:user_id] = user.canvas_uid
  end

  # TODO: Move this to a Canvas API libarary or user service
  # TODO: Find credentals for the right LMS, not just the first one.
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
