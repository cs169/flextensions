# == Schema Information
#
# Table name: api_tokens
#
#  id            :bigint           not null, primary key
#  expires_at    :datetime         not null
#  last_used_at  :datetime
#  read_write    :boolean          default(FALSE), not null
#  revoked_at    :datetime
#  token_digest  :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  course_id     :bigint           not null
#  created_by_id :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_api_tokens_on_course_id     (course_id)
#  index_api_tokens_on_created_by_id (created_by_id)
#  index_api_tokens_on_token_digest  (token_digest) UNIQUE
#  index_api_tokens_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
class APIToken < ApplicationRecord
  belongs_to :course
  belongs_to :user
  belongs_to :created_by, class_name: 'User'

  attr_accessor :raw_token

  validates :token_digest, presence: true, uniqueness: true
  validates :expires_at, presence: true
  validates :read_write, inclusion: { in: [ true, false ] }
  validate :expires_at_must_be_in_future, on: :create

  before_create :generate_token_digest

  scope :active, -> { where(revoked_at: nil).where(expires_at: Time.current..) }
  scope :expired, -> { where(expires_at: ..Time.current) }
  scope :revoked, -> { where.not(revoked_at: nil) }

  def active?
    revoked_at.nil? && expires_at > Time.current
  end

  def expired?
    expires_at <= Time.current
  end

  def revoked?
    revoked_at.present?
  end

  def revoke!
    update!(revoked_at: Time.current)
  end

  def touch_last_used!
    update!(last_used_at: Time.current)
  end

  def course_role
    UserToCourse.find_by(user_id: user_id, course_id: course_id)&.role
  end

  def self.generate_token
    SecureRandom.urlsafe_base64(32)
  end

  def self.digest(raw_token)
    Digest::SHA256.hexdigest(raw_token)
  end

  def self.lookup_token(raw_token)
    return nil if raw_token.blank?

    find_by(token_digest: digest(raw_token))
  end

  def self.authenticate(raw_token)
    token = lookup_token(raw_token)
    return nil unless token&.active?

    token.touch_last_used!
    token
  end

  private

  def generate_token_digest
    return if token_digest.present?

    self.raw_token = self.class.generate_token
    self.token_digest = self.class.digest(raw_token)
  end

  def expires_at_must_be_in_future
    return if expires_at.blank?

    errors.add(:expires_at, 'must be in the future') if expires_at <= Time.current
  end
end
