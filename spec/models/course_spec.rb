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

  before do
    Lms.create!(id: 1, lms_name: 'Canvas', use_auth_token: true)
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

  describe '.sync_assignment' do
    let!(:course) { described_class.create!(canvas_id: 'canvas_123', course_name: 'Test', course_code: 'T101') }
    let!(:course_to_lms) { CourseToLms.create!(course: course, lms_id: 1, external_course_id: 'canvas_123') }

    it 'creates or updates an assignment' do
      canvas_assignment = Lmss::Canvas::Assignment.new({ 'id' => 'a123', 'name' => 'HW1', 'due_at' => 1.day.from_now.to_s })
      expect do
        described_class.sync_assignment(course_to_lms, canvas_assignment)
      end.to change(Assignment, :count).by(1)

      assignment = Assignment.last
      expect(assignment.name).to eq('HW1')
    end
  end

  describe '.sync_assignments' do
    let!(:course) { described_class.create!(canvas_id: 'canvas_123', course_name: 'Test', course_code: 'T101') }
    let!(:course_to_lms) { CourseToLms.create!(course: course, lms_id: 1, external_course_id: 'canvas_123') }

    it 'calls sync_assignment for each assignment and deletes missing ones' do
      Assignment.create!(name: 'Old', course_to_lms_id: course_to_lms.id, external_assignment_id: 'old')

      canvas_assignment = Lmss::Canvas::Assignment.new({ 'id' => 'new1', 'name' => 'New Assignment', 'due_at' => nil })
      allow(course_to_lms).to receive(:fetch_canvas_assignments).and_return([canvas_assignment])

      # one created, one deleted
      expect do
        described_class.sync_assignments(course_to_lms, 'fake_token')
      end.not_to(change(Assignment, :count))
      expect(Assignment.find_by(external_assignment_id: 'old')).to be_nil
      expect(Assignment.find_by(external_assignment_id: 'new1')).not_to be_nil
    end
  end

  describe '#sync_users_from_canvas' do
    let!(:course) { described_class.create!(canvas_id: 'canvas_999', course_name: 'User Sync', course_code: 'USYNC') }

    before do
      stub_request(:get, %r{api/v1/courses/canvas_999/users.*})
        .to_return(status: 200, body: [{ id: 'u1', name: 'User 1', email: 'user1@example.com', sis_user_id: 'SIS123' }].to_json)
    end

    it 'creates user and user_to_course record' do
      expect do
        course.sync_users_from_canvas('fake_token', 'student')
      end.to change(User, :count).by(1).and change(UserToCourse, :count).by(1)
    end
  end

  describe '.create_or_update_from_canvas' do
    it 'creates course, course_to_lms, form_setting, syncs assignments and enrollments' do
      allow(described_class).to receive(:sync_assignments)
      allow_any_instance_of(described_class).to receive(:sync_enrollments_from_canvas)
      stub_request(:get, %r{api/v1/courses/canvas_123})
        .to_return(status: 200, body: { name: 'Intro to RSpec', course_code: 'RSPEC101' }.to_json)

      expect do
        described_class.create_or_update_from_canvas(course_data, 'fake_token', instance_double(User))
      end.to change(described_class, :count).by(1).and change(FormSetting, :count).by(1)

      expect(described_class).to have_received(:sync_assignments)
    end
  end
end
