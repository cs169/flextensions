# app/models/lms_credential.rb
# == Schema Information
#
# Table name: lms_credentials
#
#  id               :bigint           not null, primary key
#  expire_time      :datetime
#  password         :string
#  refresh_token    :string
#  token            :string
#  username         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  external_user_id :string
#  lms_id           :bigint
#  user_id          :bigint
#
# Indexes
#
#  index_lms_credentials_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (lms_id => lmss.id)
#  fk_rails_...  (user_id => users.id)
#
class LmsCredential < ApplicationRecord
  # Belongs to a User
  belongs_to :user
  belongs_to :lms, optional: true

  # Belongs to an LMS
  belongs_to :lms

  # Encryption for tokens
  encrypts :token, :refresh_token

  # LMS must exist
  validates :lms_id, presence: true
end
