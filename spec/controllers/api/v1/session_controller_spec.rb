require 'rails_helper'

RSpec.describe SessionController, type: :controller do
  describe 'GET #create' do
    let(:user_info) do
      {
        'id' => '12345',
        'name' => 'Test User',
        'primary_email' => 'test@example.com',
        'email' => 'test@example.com'
      }
    end

    let(:mock_token) do
      instance_double(OAuth2::AccessToken,
                      token: 'fake-token',
                      refresh_token: 'fake-refresh-token',
                      expires_at: Time.now.to_i + 3600)
    end

    let(:mock_auth_code) { instance_double(OAuth2::Strategy::AuthCode) }

    let(:mock_client) { instance_double(OAuth2::Client, auth_code: mock_auth_code) }

    before do
      allow(OAuth2::Client).to receive(:new).and_return(mock_client)
      allow(mock_auth_code).to receive(:get_token).and_return(mock_token)

      stub_request(:get, "#{ENV.fetch('CANVAS_URL', nil)}/api/v1/users/self?")
        .with(headers: { 'Authorization' => 'Bearer fake-token' })
        .to_return(status: 200, body: user_info.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'creates a user and redirects to courses_path' do
      get :create, params: { code: 'valid-code' }

      user = User.find_by(canvas_uid: '12345')
      expect(user).not_to be_nil
      expect(user.email).to eq('test@example.com')

      expect(session[:user_id]).to eq('12345')
      expect(response).to redirect_to(courses_path)
      expect(flash[:notice]).to eq('Logged in!')
    end

    it 'redirects to root_path if token is missing or error param is present' do
      get :create, params: { error: 'access_denied' }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Authentication failed. Please try again.')
    end

    it 'redirects to root_path if Canvas API call fails' do
      stub_request(:get, "#{ENV.fetch('CANVAS_URL', nil)}/api/v1/users/self?")
        .to_return(status: 401)

      get :create, params: { code: 'bad-code' }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Authentication failed. Invalid token.')
    end
  end
end
