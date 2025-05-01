require 'rails_helper'

RSpec.describe SessionController, type: :controller do
  describe 'GET #omniauth_callback' do
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
                      refresh_token: 'fake-refresh',
                      expires_at: Time.now.to_i + 3600)
    end

    let(:mock_auth_code) { instance_double(OAuth2::Strategy::AuthCode) }
    let(:mock_client) { instance_double(OAuth2::Client, auth_code: mock_auth_code) }

    before do
      allow(OAuth2::Client).to receive(:new).and_return(mock_client)
      allow(mock_auth_code).to receive(:get_token).and_return(mock_token)

      stub_request(:get, "#{ENV.fetch('CANVAS_URL')}/api/v1/users/self?")
        .with(headers: { 'Authorization' => 'Bearer fake-token' })
        .to_return(status: 200, body: user_info.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'creates a new user and redirects to courses_path' do
      get :omniauth_callback, params: { provider: 'canvas', code: 'valid-code' }, session: {}

      user = User.find_by(canvas_uid: '12345')
      expect(user).not_to be_nil
      expect(user.email).to eq('test@example.com')
      expect(session[:user_id]).to eq('12345')
      expect(response).to redirect_to(courses_path)
      expect(flash[:notice]).to eq('Logged in!')
    end

    it 'redirects to root_path if code is missing' do
      get :omniauth_callback, params: { provider: 'canvas', code: '' }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Authentication failed. Please try again.')
    end

    it 'redirects to root_path if Canvas API call fails' do
      stub_request(:get, "#{ENV.fetch('CANVAS_URL')}/api/v1/users/self?")
        .to_return(status: 401)

      get :omniauth_callback, params: { provider: 'canvas', code: 'invalid-code' }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Authentication failed. Invalid token.')
    end
  end

  describe '#find_or_create_user and #update_user_credential' do
    let(:user_data) do
      {
        'id' => '12345',
        'name' => 'Test User',
        'primary_email' => 'test@example.com',
        'email' => 'test@example.com'
      }
    end

    let(:mock_token) do
      instance_double(OAuth2::AccessToken,
                      token: 'new-token',
                      refresh_token: 'new-refresh',
                      expires_at: 2.hours.from_now.to_i)
    end

    context 'when user exists by email' do
      let!(:existing_user) { User.create!(email: 'test@example.com', canvas_uid: 'old_uid') }

      it 'updates canvas_uid and LMS credentials' do
        expect do
          controller.send(:find_or_create_user, user_data, mock_token)
        end.to change { existing_user.reload.canvas_uid }.from('old_uid').to('12345')

        creds = existing_user.reload.lms_credentials.first
        expect(creds.token).to eq('new-token')
      end
    end

    context 'when user exists by canvas_uid' do
      let!(:existing_user) { User.create!(email: 'old@example.com', canvas_uid: '12345') }

      it 'updates email and LMS credentials' do
        expect do
          controller.send(:find_or_create_user, user_data, mock_token)
        end.to change { existing_user.reload.email }.from('old@example.com').to('test@example.com')
      end
    end

    context 'when user is new' do
      it 'creates the user and LMS credentials' do
        expect do
          controller.send(:find_or_create_user, user_data, mock_token)
        end.to change(User, :count).by(1)

        user = User.find_by(canvas_uid: '12345')
        expect(user.email).to eq('test@example.com')
        expect(user.lms_credentials.first.token).to eq('new-token')
      end
    end
  end
end
