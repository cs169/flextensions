# spec/models/lms_credential_spec.rb
# == Schema Information
#
# Table name: lms_credentials
#
#  id               :bigint           not null, primary key
#  expire_time      :datetime
#  lms_name         :string
#  password         :string
#  refresh_token    :string
#  token            :string
#  username         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  external_user_id :string
#  user_id          :bigint
#
# Indexes
#
#  index_lms_credentials_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

class MockCanvas
  # Simulate authentication using a token and refresh token
  def self.authenticate(token, refresh_token)
    token == 'sensitive_token' && refresh_token == 'sensitive_refresh_token'
  end

  # Simulate retrieving a service, returning 'service_object' if credentials are valid
  def self.mock_get_service(token, refresh_token)
    authenticate(token, refresh_token) ? 'service_object' : nil
  end
end

RSpec.describe LmsCredential, type: :model do
  describe 'Token Encryption' do
    let(:user) { User.create!(email: 'test@example.com') }
    let!(:credential) do
      described_class.create!(
        user: user,
        lms_name: 'ExampleLMS',
        username: 'testuser',
        password: 'testpassword',
        token: 'sensitive_token',
        refresh_token: 'sensitive_refresh_token'
      )
    end

    it 'encrypts the token and refresh_token' do
      raw_token = ActiveRecord::Base.connection.execute(
        "SELECT token FROM lms_credentials WHERE id = #{credential.id}"
      ).first['token']
      raw_refresh_token = ActiveRecord::Base.connection.execute(
        "SELECT refresh_token FROM lms_credentials WHERE id = #{credential.id}"
      ).first['refresh_token']

      expect(raw_token).not_to eq 'sensitive_token'
      expect(raw_refresh_token).not_to eq 'sensitive_refresh_token'
      expect(credential.token).to eq 'sensitive_token'
      expect(credential.refresh_token).to eq 'sensitive_refresh_token'
    end

    it 'decrypts the token and refresh_token for use' do
      expect(credential.token).to eq('sensitive_token')
      expect(credential.refresh_token).to eq('sensitive_refresh_token')

      # Simulate a call to get a service object
      expect(MockCanvas.mock_get_service(credential.token, credential.refresh_token)).to eq('service_object')
    end
  end
end
