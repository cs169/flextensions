# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#token_expired?' do
    let(:user) { User.create!(email: 'test@example.com', canvas_uid: '123') }

    context 'when there are no credentials' do
      it 'returns false' do
        expect(user.token_expired?).to be false
      end
    end

    context 'when the token is still valid' do
      before do
        user.lms_credentials.create!(
          lms_name: 'canvas',
          token: 'valid_token',
          refresh_token: 'refresh_token',
          expire_time: 1.hour.from_now
        )
      end

      it 'returns false' do
        expect(user.token_expired?).to be false
      end
    end

    context 'when the token is expired' do
      before do
        user.lms_credentials.create!(
          lms_name: 'canvas',
          token: 'expired_token',
          refresh_token: 'refresh_token',
          expire_time: 1.hour.ago
        )
      end

      it 'returns true' do
        expect(user.token_expired?).to be true
      end
    end
  end

  describe '#ensure_fresh_token' do
    let(:user) { User.create!(email: 'test@example.com', canvas_uid: '123') }

    context 'when token does not expire soon' do
      before do
        user.lms_credentials.create!(
          lms_name: 'canvas',
          token: 'valid_token',
          refresh_token: 'refresh_token',
          expire_time: 1.hour.from_now
        )
      end

      it 'returns the current token' do
        expect(user.ensure_fresh_token).to eq('valid_token')
      end
    end

    context 'when token expires soon and is refreshed' do
      let!(:credential) do
        user.lms_credentials.create!(
          lms_name: 'canvas',
          token: 'stale_token',
          refresh_token: 'refresh_token',
          expire_time: 5.minutes.from_now
        )
      end
    
      it 'calls refresh_user_token and returns the current token' do
        allow(user).to receive(:token_expires_soon?).and_return(true)
    
        # Spy on a specific instance of SessionController
        session_controller = instance_double(SessionController)
        allow(SessionController).to receive(:new).and_return(session_controller)
        allow(session_controller).to receive(:refresh_user_token).with(user).and_return('refreshed_token')
    
        result = user.ensure_fresh_token
    
        expect(session_controller).to have_received(:refresh_user_token).with(user)
        expect(result).to eq('stale_token') # The method returns the credential token, which isn’t updated by default in this test
      end
    end    
  end
end
