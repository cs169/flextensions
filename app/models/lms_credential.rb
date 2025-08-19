# app/models/lms_credential.rb
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
class LmsCredential < ApplicationRecord
  # Belongs to a User
  belongs_to :user

  # Encryption for tokens
  encrypts :token, :refresh_token

  # LMS must exist
  validates :lms_name, presence: true
end
