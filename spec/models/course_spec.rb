# == Schema Information
#
# Table name: courses
#
#  id                 :bigint           not null, primary key
#  course_code        :string
#  course_name        :string
#  readonly_api_token :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  canvas_id          :string
#
# Indexes
#
#  index_courses_on_canvas_id           (canvas_id) UNIQUE
#  index_courses_on_readonly_api_token  (readonly_api_token) UNIQUE
#
require 'rails_helper'
RSpec.describe Course, type: :model do
  let(:course_data) do
    {
      'id' => 'canvas_123',
      'name' => 'Intro to RSpec',
      'course_code' => 'RSPEC101'
    }
  end

  CANVAS_USERS = [
    { "id": 246, "name": "Lloyd Beck", "created_at": "2025-05-05T11:57:47-07:00", "sortable_name": "Beck, Lloyd", "short_name": "Lloyd Beck", "sis_user_id": "235790602", "integration_id": "lloyd.beck64", "sis_import_id": 5, "login_id": "lloyd.beck64@example.com", "email": "lloyd.beck64@example.com", "has_non_collaborative_groups": false },
    { "id": 250, "name": "Ida Bowman", "created_at": "2025-05-05T11:57:54-07:00", "sortable_name": "Bowman, Ida", "short_name": "Ida Bowman", "sis_user_id": "238436601", "integration_id": "ida.bowman96", "sis_import_id": 5, "login_id": "ida.bowman96@example.com", "email": "ida.bowman96@example.com", "has_non_collaborative_groups": false },
    { "id": 241, "name": "Chad Carter", "created_at": "2025-05-05T11:57:38-07:00", "sortable_name": "Carter, Chad", "short_name": "Chad Carter", "sis_user_id": "217390501", "integration_id": "chad.carter67", "sis_import_id": 5, "login_id": "chad.carter67@example.com", "email": "chad.carter67@example.com", "has_non_collaborative_groups": false },
    { "id": 247, "name": "Vanessa Gonzalez", "created_at": "2025-05-05T11:57:48-07:00", "sortable_name": "Gonzalez, Vanessa", "short_name": "Vanessa Gonzalez", "sis_user_id": "236117342", "integration_id": "vanessa.gonzalez33", "sis_import_id": 5, "login_id": "vanessa.gonzalez33@example.com", "email": "vanessa.gonzalez33@example.com", "has_non_collaborative_groups": false },
    { "id": 237, "name": "Paul Gregory", "created_at": "2025-05-05T11:57:31-07:00", "sortable_name": "Gregory, Paul", "short_name": "Paul Gregory", "sis_user_id": "208245419", "integration_id": "paul.gregory86", "sis_import_id": 5, "login_id": "paul.gregory86@example.com", "email": "paul.gregory86@example.com", "has_non_collaborative_groups": false },
    { "id": 238, "name": "Kent Hansen", "created_at": "2025-05-05T11:57:33-07:00", "sortable_name": "Hansen, Kent", "short_name": "Kent Hansen", "sis_user_id": "208932635", "integration_id": "kent.hansen98", "sis_import_id": 5, "login_id": "kent.hansen98@example.com", "email": "kent.hansen98@example.com", "has_non_collaborative_groups": false },
    { "id": 239, "name": "Becky Hayes", "created_at": "2025-05-05T11:57:35-07:00", "sortable_name": "Hayes, Becky", "short_name": "Becky Hayes", "sis_user_id": "214359068", "integration_id": "becky.hayes43", "sis_import_id": 5, "login_id": "becky.hayes43@example.com", "email": "becky.hayes43@example.com", "has_non_collaborative_groups": false },
    { "id": 240, "name": "Sherri Johnson", "created_at": "2025-05-05T11:57:36-07:00", "sortable_name": "Johnson, Sherri", "short_name": "Sherri Johnson", "sis_user_id": "216573718", "integration_id": "sherri.johnson53", "sis_import_id": 5, "login_id": "sherri.johnson53@example.com", "email": "sherri.johnson53@example.com", "has_non_collaborative_groups": false }
  ]

  describe '#staff_user_for_auto_approval' do
    it 'returns the correct user for auto approval' do
      course = described_class.create!(canvas_id: 'canvas_123', course_name: 'Test', course_code: 'TEST101')
      user = User.create!(email: 'test@example.com', canvas_uid: '123')
      user.lms_credentials.create!(
        lms_name: 'canvas',
        token: 'valid_token',
        refresh_token: 'refresh_token',
        expire_time: 1.hour.from_now
      )
      UserToCourse.create!(user: user, course: course, role: 'ta')

      staff_user = course.staff_user_for_auto_approval
      expect(staff_user).to eq(user)
    end
  end

  describe '.fetch_courses' do
    it 'returns parsed JSON if response is successful' do
      stub_request(:get, %r{api/v1/courses})
        .to_return(status: 200, body: '[{"id": "canvas_123"}]')

      result = described_class.fetch_courses('fake_token')
      expect(result).to be_an(Array)
      expect(result.first['id']).to eq('canvas_123')
    end

    it 'logs and returns empty array on failure' do
      stub_request(:get, %r{api/v1/courses}).to_return(status: 401, body: 'Unauthorized')

      expect(Rails.logger).to receive(:error).with(/Failed to fetch courses/)
      result = described_class.fetch_courses('fake_token')
      expect(result).to eq([])
    end
  end

  describe '.find_or_create_course' do
    let(:token) { 'fake_token' }

    it 'creates a new course if not found' do
      # Stub the Faraday request
      stub_request(:get, %r{api/v1/courses/canvas_123})
        .to_return(status: 200, body: { name: 'Intro to RSpec', course_code: 'RSPEC101' }.to_json)

      # Call the method
      course = described_class.find_or_create_course(course_data, token)

      # Expectations
      expect(course).to be_persisted
      expect(course.course_name).to eq('Intro to RSpec')
      expect(course.course_code).to eq('RSPEC101')
    end

    it 'returns existing course if already created' do
      # Create an existing course
      existing = described_class.create!(canvas_id: 'canvas_123', course_name: 'Intro to RSpec', course_code: 'RSPEC101')

      # Stub the Faraday request
      stub_request(:get, %r{api/v1/courses/canvas_123})
        .to_return(status: 200, body: { name: 'Intro to RSpec', course_code: 'RSPEC101' }.to_json)

      # Call the method
      course = described_class.find_or_create_course(course_data, token)

      # Expectations
      expect(course.id).to eq(existing.id)
      expect(course.course_name).to eq('Intro to RSpec')
      expect(course.course_code).to eq('RSPEC101')
    end
  end

  describe '.find_or_create_course_to_lms' do
    let!(:course) { described_class.create!(canvas_id: 'canvas_123', course_name: 'Test', course_code: 'TEST101') }

    it 'creates a new CourseToLms if not exists' do
      result = described_class.find_or_create_course_to_lms(course, course_data)
      expect(result).to be_persisted
      expect(result.external_course_id).to eq('canvas_123')
    end
end

  describe '#sync_users_from_canvas' do
    let!(:course) { described_class.create!(canvas_id: 'canvas_999', course_name: 'User Sync', course_code: 'USYNC') }
    let(:course_to_lms) { CourseToLms.create!(course: course, external_course_id: 'canvas_999', lms_id: 1) }
    let(:user) { create(:user, id: 999, canvas_uid: 'u1', name: 'User 1', email: 'user1@example.com') }

    before do
      course_to_lms
      stub_request(:get, %r{api/v1/courses/canvas_999/users.*})
        .to_return(
          status: 200,
          body: CANVAS_USERS.to_json
        )
      allow(user).to receive(:ensure_fresh_canvas_token!).and_return('fake_token')
    end

    it 'creates user and user_to_course record' do
      expect do
        course.sync_users_from_canvas(user.id, 'student')
      end.to change(User, :count).by(CANVAS_USERS.size).and(
        change(UserToCourse, :count).by(CANVAS_USERS.size)
      )
    end
  end

  describe '.create_or_update_from_canvas' do
    let(:user) { create(:user, id: 999, canvas_uid: 'u1', name: 'User 1', email: 'user1@example.com') }

    it 'creates course, course_to_lms, form_setting, syncs assignments and enrollments' do
      expect_any_instance_of(described_class).to receive(:sync_assignments)

      stub_request(:get, %r{api/v1/courses/canvas_123})
        .to_return(status: 200, body: { name: 'Intro to RSpec', course_code: 'RSPEC101' }.to_json)

      expect do
        described_class.create_or_update_from_canvas(course_data, 'fake_token', user)
      end.to change(described_class, :count).by(1).and change(FormSetting, :count).by(1)
    end
  end
end
