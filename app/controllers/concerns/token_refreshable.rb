module TokenRefreshable
  extend ActiveSupport::Concern

  # Ensure user has a valid token before making API calls
  def with_valid_token(user)
    return yield(user.lms_credentials.first.token) unless token_expires_soon?(user)

    # Token is expiring soon, refresh it
    new_token = refresh_user_token(user)

    if new_token
      yield(new_token)
    else
      Rails.logger.error "Failed to refresh token for user #{user.id}"
      raise 'Invalid authentication token'
    end
  end

  private

  def refresh_user_token(user)
    credential = user.lms_credentials.first
    return unless credential&.refresh_token

    client = create_oauth_client

    begin
      token = OAuth2::AccessToken.from_hash(
        client,
        refresh_token: credential.refresh_token
      ).refresh!

      credential.update(
        token: token.token,
        refresh_token: token.refresh_token || credential.refresh_token,
        expire_time: Time.zone.at(token.expires_at)
      )

      token.token
    rescue OAuth2::Error => e
      Rails.logger.error "Failed to refresh token: #{e.message}"
      nil
    end
  end

  def token_expires_soon?(user)
    credential = user.lms_credentials.first
    credential&.expire_time.present? && credential.expire_time < 5.minutes.from_now
  end

  def create_oauth_client
    OAuth2::Client.new(
      ENV.fetch('CANVAS_CLIENT_ID', nil),
      ENV.fetch('APP_KEY', nil),
      site: ENV.fetch('CANVAS_URL', nil),
      token_url: '/login/oauth2/token'
    )
  end
end
