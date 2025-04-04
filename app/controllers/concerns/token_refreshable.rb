module TokenRefreshable
  extend ActiveSupport::Concern

  # Ensure user has a valid token before making API calls
  def with_valid_token(user)
    return yield(user.lms_credentials.first.token) unless user.token_expires_soon?
    
    # Token is expiring soon, refresh it
    new_token = refresh_user_token(user)
    
    if new_token
      # Return the block with the new token
      yield(new_token)
    else
      # Token refresh failed
      Rails.logger.error "Failed to refresh token for user #{user.id}"
      raise "Invalid authentication token"
    end
  end
  
  private
  
  def refresh_user_token(user)
    # Get the user's credentials
    credential = user.lms_credentials.first
    return unless credential&.refresh_token

    # Create OAuth2 client
    client = OAuth2::Client.new(
      ENV.fetch('CANVAS_CLIENT_ID', nil),
      ENV.fetch('APP_KEY', nil),
      site: ENV.fetch('CANVAS_URL', nil),
      token_url: '/login/oauth2/token'
    )

    # Use refresh token to get a new access token
    begin
      token = OAuth2::AccessToken.from_hash(
        client,
        refresh_token: credential.refresh_token
      ).refresh!

      # Update the user's credentials with the new token
      credential.update(
        token: token.token,
        refresh_token: token.refresh_token || credential.refresh_token, # Keep old refresh token if new one not provided
        expire_time: Time.zone.at(token.expires_at)
      )
      
      return token.token
    rescue OAuth2::Error => e
      Rails.logger.error "Failed to refresh token: #{e.message}"
      return nil
    end
  end
end 