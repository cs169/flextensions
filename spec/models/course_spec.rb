require 'rails_helper'
RSpec.describe Course, type: :model do
  let(:course_data) do
    {
      'id' => 'canvas_123',
      'name' => 'Intro to RSpec',
      'course_code' => 'RSPEC101'
    }
  end
  before do
    Lms.create!(id: 1, lms_name: 'Canvas', use_auth_token: true)

  end
  describe '.fetch_courses' do
    it 'returns parsed JSON if response is successful' do
      stub_request(:get, /api\/v1\/courses/)
        .to_return(status: 200, body: '[{"id": "canvas_123"}]')

      result = Course.fetch_courses('fake_token')
      expect(result).to be_an(Array)
      expect(result.first['id']).to eq('canvas_123')
    end

    it 'logs and returns empty array on failure' do
      stub_request(:get, /api\/v1\/courses/).to_return(status: 401, body: 'Unauthorized')

      expect(Rails.logger).to receive(:error).with(/Failed to fetch courses/)
      result = Course.fetch_courses('fake_token')
      expect(result).to eq([])
    end
  end

  describe '.find_or_create_course' do
    it 'creates a new course if not found' do
      course = Course.find_or_create_course(course_data)
      expect(course).to be_persisted
      expect(course.course_name).to eq('Intro to RSpec')
    end

    it 'returns existing course if already created' do
      existing = Course.create!(canvas_id: 'canvas_123', course_name: 'Intro to RSpec', course_code: 'RSPEC101')
      course = Course.find_or_create_course(course_data)
      expect(course.id).to eq(existing.id)
    end
  end

  describe '.find_or_create_course_to_lms' do
    let!(:course) { Course.create!(canvas_id: 'canvas_123', course_name: 'Test', course_code: 'TEST101') }

    it 'creates a new CourseToLms if not exists' do
      result = Course.find_or_create_course_to_lms(course, course_data)
      expect(result).to be_persisted
      expect(result.external_course_id).to eq('canvas_123')
    end
  end

  describe '.sync_assignment' do
    let!(:course) { Course.create!(canvas_id: 'canvas_123', course_name: 'Test', course_code: 'T101') }
    let!(:course_to_lms) { CourseToLms.create!(course: course, lms_id: 1, external_course_id: 'canvas_123') }

    it 'creates or updates an assignment' do
      assignment_data = { 'id' => 'a123', 'name' => 'HW1', 'due_at' => 1.day.from_now.to_s }
      expect {
        Course.sync_assignment(course_to_lms, assignment_data)
      }.to change { Assignment.count }.by(1)

      assignment = Assignment.last
      expect(assignment.name).to eq('HW1')
    end
  end

  describe '.sync_assignments' do
    let!(:course) { Course.create!(canvas_id: 'canvas_123', course_name: 'Test', course_code: 'T101') }
    let!(:course_to_lms) { CourseToLms.create!(course: course, lms_id: 1, external_course_id: 'canvas_123') }

    it 'calls sync_assignment for each assignment and deletes missing ones' do
      Assignment.create!(name: 'Old', course_to_lms_id: course_to_lms.id, external_assignment_id: 'old')

      allow(course_to_lms).to receive(:fetch_assignments).and_return([
        { 'id' => 'new1', 'name' => 'New Assignment', 'due_at' => nil }
      ])

      expect {
        Course.sync_assignments(course_to_lms, 'fake_token')
      }.to change { Assignment.count }.by(0) # one created, one deleted

      expect(Assignment.find_by(external_assignment_id: 'old')).to be_nil
      expect(Assignment.find_by(external_assignment_id: 'new1')).not_to be_nil
    end
  end

  describe '#sync_users_from_canvas' do
    let!(:course) { Course.create!(canvas_id: 'canvas_999', course_name: 'User Sync', course_code: 'USYNC') }

    before do
      stub_request(:get, /api\/v1\/courses\/canvas_999\/users.*/)
        .to_return(status: 200, body: [{ id: 'u1', name: 'User 1', email: 'user1@example.com', sis_user_id: 'SIS123' }].to_json)
    end

    it 'creates user and user_to_course record' do
      expect {
        course.sync_users_from_canvas('fake_token', 'student')
      }.to change { User.count }.by(1).and change { UserToCourse.count }.by(1)
    end
  end

  describe '.create_or_update_from_canvas' do
    it 'creates course, course_to_lms, form_setting, syncs assignments and enrollments' do
      allow(Course).to receive(:sync_assignments)
      allow_any_instance_of(Course).to receive(:sync_enrollments_from_canvas)

      expect {
        Course.create_or_update_from_canvas(course_data, 'fake_token', double(:user))
      }.to change { Course.count }.by(1).and change { FormSetting.count }.by(1)

      expect(Course).to have_received(:sync_assignments)
    end
  end
end