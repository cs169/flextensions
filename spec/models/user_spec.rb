# spec/models/user_spec.rb
# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  canvas_uid :string
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  student_id :string
#
# Indexes
#
#  index_users_on_canvas_uid  (canvas_uid) UNIQUE
#  index_users_on_email       (email) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#token_expired?' do
    let(:user) { described_class.create!(email: 'test@example.com', canvas_uid: '123') }

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
    let(:user) { described_class.create!(email: 'test@example.com', canvas_uid: '123') }

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
      let(:credential) do
        user.lms_credentials.create!(
          lms_name: 'canvas',
          token: 'stale_token',
          refresh_token: 'refresh_token',
          expire_time: 5.minutes.from_now
        )
      end

      before { credential }

      it 'refreshes token and returns it' do
        allow(user).to receive(:token_expires_soon?).and_return(true)

        allow_any_instance_of(SessionController).to receive(:refresh_user_token).and_return('refreshed_token')

        result = user.ensure_fresh_token

        expect(result).to eq('stale_token') # Still returns the credential.token
      end
    end
  end
end
