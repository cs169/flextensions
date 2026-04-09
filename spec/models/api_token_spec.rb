require 'rails_helper'

RSpec.describe ApiToken, type: :model do
  let(:course) { Course.create!(course_name: 'Test Course', canvas_id: 'canvas_1') }
  let(:user) { User.create!(email: 'user@example.com', canvas_uid: '100', name: 'Test User') }
  let(:creator) { User.create!(email: 'creator@example.com', canvas_uid: '101', name: 'Creator') }

  describe 'associations' do
    it { is_expected.to belong_to(:course) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:created_by).class_name('User') }
  end

  describe 'validations' do
    it 'requires expires_at' do
      token = described_class.new(course: course, user: user, created_by: creator, expires_at: nil)
      token.valid?
      expect(token.errors[:expires_at]).to include("can't be blank")
    end

    it 'requires expires_at to be in the future on create' do
      token = described_class.new(
        course: course, user: user, created_by: creator,
        expires_at: 1.day.ago
      )
      token.valid?
      expect(token.errors[:expires_at]).to include('must be in the future')
    end

    it 'allows expires_at in the past on update (for already-expired tokens)' do
      token = described_class.create!(course: course, user: user, created_by: creator, expires_at: 2.days.from_now)
      # Simulate time passing by updating directly
      token.update_column(:expires_at, 1.day.ago)
      token.reload
      # Updating a different field should still be valid
      token.revoked_at = Time.current
      expect(token).to be_valid
    end
  end

  describe 'token generation' do
    it 'generates raw_token and token_digest on create' do
      token = described_class.create!(course: course, user: user, created_by: creator, expires_at: 30.days.from_now)
      expect(token.raw_token).to be_present
      expect(token.token_digest).to be_present
    end

    it 'stores digest as SHA256 of raw_token' do
      token = described_class.create!(course: course, user: user, created_by: creator, expires_at: 30.days.from_now)
      expected_digest = Digest::SHA256.hexdigest(token.raw_token)
      expect(token.token_digest).to eq(expected_digest)
    end

    it 'does not persist raw_token' do
      token = described_class.create!(course: course, user: user, created_by: creator, expires_at: 30.days.from_now)
      reloaded = described_class.find(token.id)
      expect(reloaded.raw_token).to be_nil
    end

    it 'does not regenerate token_digest if already set' do
      digest = Digest::SHA256.hexdigest('pre-existing-token')
      token = described_class.create!(
        course: course, user: user, created_by: creator,
        token_digest: digest, expires_at: 30.days.from_now
      )
      expect(token.token_digest).to eq(digest)
    end
  end

  describe 'scopes' do
    let!(:active_token) do
      described_class.create!(course: course, user: user, created_by: creator, expires_at: 30.days.from_now)
    end
    let!(:expired_token) do
      t = described_class.create!(course: course, user: user, created_by: creator, expires_at: 2.days.from_now)
      t.update_column(:expires_at, 1.day.ago)
      t
    end
    let!(:revoked_token) do
      t = described_class.create!(course: course, user: user, created_by: creator, expires_at: 30.days.from_now)
      t.update!(revoked_at: Time.current)
      t
    end

    it '.active returns only active tokens' do
      expect(described_class.active).to contain_exactly(active_token)
    end

    it '.expired returns only expired tokens' do
      expect(described_class.expired).to contain_exactly(expired_token)
    end

    it '.revoked returns only revoked tokens' do
      expect(described_class.revoked).to contain_exactly(revoked_token)
    end
  end

  describe 'instance methods' do
    let(:token) do
      described_class.create!(course: course, user: user, created_by: creator, expires_at: 30.days.from_now)
    end

    describe '#active?' do
      it 'returns true for non-revoked, non-expired token' do
        expect(token.active?).to be true
      end

      it 'returns false for expired token' do
        token.update_column(:expires_at, 1.day.ago)
        expect(token.reload.active?).to be false
      end

      it 'returns false for revoked token' do
        token.revoke!
        expect(token.active?).to be false
      end
    end

    describe '#revoke!' do
      it 'sets revoked_at' do
        expect { token.revoke! }.to change { token.revoked_at }.from(nil)
        expect(token.revoked_at).to be_within(1.second).of(Time.current)
      end
    end

    describe '#touch_last_used!' do
      it 'updates last_used_at' do
        expect { token.touch_last_used! }.to change { token.reload.last_used_at }.from(nil)
        expect(token.last_used_at).to be_within(1.second).of(Time.current)
      end
    end

    describe '#course_role' do
      it 'returns the role from UserToCourse' do
        UserToCourse.create!(user: user, course: course, role: 'teacher')
        expect(token.course_role).to eq('teacher')
      end

      it 'returns nil when no enrollment exists' do
        expect(token.course_role).to be_nil
      end
    end
  end

  describe 'class methods' do
    describe '.find_by_raw_token' do
      it 'finds token by raw value' do
        token = described_class.create!(course: course, user: user, created_by: creator, expires_at: 30.days.from_now)
        found = described_class.find_by_raw_token(token.raw_token)
        expect(found).to eq(token)
      end

      it 'returns nil for invalid token' do
        expect(described_class.find_by_raw_token('nonexistent')).to be_nil
      end

      it 'returns nil for blank token' do
        expect(described_class.find_by_raw_token('')).to be_nil
        expect(described_class.find_by_raw_token(nil)).to be_nil
      end
    end

    describe '.authenticate' do
      it 'returns token and touches last_used_at for valid token' do
        token = described_class.create!(course: course, user: user, created_by: creator, expires_at: 30.days.from_now)
        result = described_class.authenticate(token.raw_token)
        expect(result).to eq(token)
        expect(result.reload.last_used_at).to be_within(1.second).of(Time.current)
      end

      it 'returns nil for expired token' do
        token = described_class.create!(course: course, user: user, created_by: creator, expires_at: 2.days.from_now)
        raw = token.raw_token
        token.update_column(:expires_at, 1.day.ago)
        expect(described_class.authenticate(raw)).to be_nil
      end

      it 'returns nil for revoked token' do
        token = described_class.create!(course: course, user: user, created_by: creator, expires_at: 30.days.from_now)
        raw = token.raw_token
        token.revoke!
        expect(described_class.authenticate(raw)).to be_nil
      end

      it 'returns nil for invalid token string' do
        expect(described_class.authenticate('invalid_token')).to be_nil
      end
    end
  end
end
