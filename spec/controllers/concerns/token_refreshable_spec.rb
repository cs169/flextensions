require 'rails_helper'

RSpec.describe TokenRefreshable, type: :controller do
  controller(ApplicationController) do
    # rubocop:disable RSpec/DescribedClass
    include TokenRefreshable
    # rubocop:enable RSpec/DescribedClass


    def dummy_action
      with_valid_token(current_user) do |token|
        render plain: "Token: #{token}"
      end
    end

    private

    def current_user
      @current_user ||= User.find(session[:user_id])
    end
  end

  let(:user) do
    User.create!(email: 'test@example.com', canvas_uid: '123').tap do |u|
      u.lms_credentials.create!(
        lms_name: 'canvas',
        token: 'valid_token',
        refresh_token: 'refresh_token',
        expire_time: 10.minutes.from_now
      )
    end
  end

  before do
    stub_request(:post, "#{ENV.fetch('CANVAS_URL', nil)}/login/oauth2/token")
      .with(
        body: { 'grant_type' => 'refresh_token', 'refresh_token' => 'refresh_token' },
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Basic MjY1MzAwMDAwMDAwMDAwMDA0OkxZazZLd0xEQXkyTmtQNk1hTDdQZkRES0MzeFRQeTZ1a21EY1d4TkFyeXYzMjhDck5HQXR0VnVaaDl4Unl5Tmg=',
          'Content-Type' => 'application/x-www-form-urlencoded',
          'User-Agent' => 'Faraday v2.12.2'
        }
      )
      .to_return(status: 200, body: '', headers: {})
    routes.draw { get 'dummy_action' => 'anonymous#dummy_action' }
    session[:user_id] = user.id
  end

  describe '#with_valid_token' do
    context 'when token is not expiring soon' do
      it 'yields with current token' do
        user_double = instance_double(User, lms_credentials: user.lms_credentials, token_expires_soon?: false)

        allow(controller).to receive(:current_user).and_return(user_double)

        get :dummy_action
        expect(response.body).to eq('Token: valid_token')
      end
    end

    context 'when token is expiring soon and refresh succeeds' do
      it 'refreshes token and yields with new token' do
        allow(user).to receive(:token_expires_soon?).and_return(true)

        new_token = instance_double(OAuth2::AccessToken,
                                    token: 'refreshed_token',
                                    refresh_token: 'new_refresh',
                                    expires_at: 1.hour.from_now.to_i)

        allow(OAuth2::AccessToken).to receive(:from_hash).and_return(new_token)
        allow(new_token).to receive(:refresh!).and_return(new_token)

        get :dummy_action
        expect(response.body).to eq('Token: refreshed_token')
        expect(user.lms_credentials.first.reload.token).to eq('refreshed_token')
      end
    end

    context 'when token is expiring soon and refresh fails' do
      it 'raises an error and logs it' do
        allow(user).to receive(:token_expires_soon?).and_return(true)

        fake_response = instance_double(OAuth2::Response, parsed: {}, status: 401)
        allow(OAuth2::AccessToken).to receive(:from_hash).and_raise(OAuth2::Error.new(fake_response))

        expect { get :dummy_action }.to raise_error('Invalid authentication token')
      end
    end
  end
end
