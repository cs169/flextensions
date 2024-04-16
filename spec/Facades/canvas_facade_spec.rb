require 'date'
require 'json'
require 'ostruct'
require 'rails_helper'
require 'timecop'

describe CanvasFacade do
  let(:mockAuthToken) { 'testAuthToken' }
  let(:mockCourseId) { 16 }
  let(:mockStudentId) { 22 }
  let(:mockAssignmentId) { 18 }
  let(:mockTitle) { 'mockOverrideTitle' }
  let(:mockDate) { '2002-03-16:16:00:00Z' }
  let(:mockOverrideId) { 8 }
  let(:mockOverride) { {
    id:            mockOverrideId,
    assignment_id: mockAssignmentId,
    title:         'mockOverrideTitle',
    due_at:        mockDate,
    unlock_at:     mockDate,
    lock_at:       mockDate,
    student_ids:   [mockStudentId]
  } }

  describe('initialization') do
    it 'sets the proper URL' do
      expect(Faraday).to receive(:new).with(hash_including(
        url: "#{ENV['CANVAS_URL']}/api/v1",
      ))
      described_class.new(mockAuthToken)
    end

    it 'sets the proper token' do
      expect(Faraday).to receive(:new).with(hash_including(
        headers: {
          Authorization: "Bearer #{mockAuthToken}"
        }
      ))
      described_class.new(mockAuthToken)
    end
  end

  # Used https://danielabaron.me/blog/testing-faraday-with-rspec/ as reference.
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) { Faraday.new { |builder| builder.adapter(:test, stubs) } }
  let(:facade) { described_class.new(mockAuthToken, conn) }

  # Allows each  test to have its own set of stubs.
  after do
    Faraday.default_connection = nil
  end

  describe 'get_all_courses' do
    before do
      stubs.get('courses') { [200, {}, '{}'] }
    end

    it 'has correct response body on successful call' do
      expect(facade.get_all_courses.body).to eq('{}')
      stubs.verify_stubbed_calls
    end
  end

  describe 'get_course' do
    before do
      stubs.get("courses/#{mockCourseId}") { [200, {}, '{}'] }
    end

    it 'has correct response body on successful call' do
      expect(facade.get_course(mockCourseId).body).to eq('{}')
      stubs.verify_stubbed_calls
    end
  end

  describe('get_assignments') do
    before do
      stubs.get("courses/#{mockCourseId}/assignments") { [200, {}, '{}'] }
    end

    it 'has correct response body on successful call' do
      expect(facade.get_assignments(mockCourseId).body).to eq('{}')
      stubs.verify_stubbed_calls
    end
  end

  describe('get_assignment') do
    before do
      stubs.get("courses/#{mockCourseId}/assignments/#{mockAssignmentId}") { [200, {}, '{}'] }
    end

    it 'has correct response body on successful call' do
      expect(facade.get_assignment(mockCourseId, mockAssignmentId).body).to eq('{}')
      stubs.verify_stubbed_calls
    end
  end

  describe('get_assignment_overrides') do
    before do
      stubs.get(
        "courses/#{mockCourseId}/assignments/#{mockAssignmentId}/overrides"
      ) { [200, {}, '{}'] }
    end

    it 'has correct response body on successful call' do
      expect(facade.get_assignment_overrides(mockCourseId, mockAssignmentId).body).to eq('{}')
      stubs.verify_stubbed_calls
    end
  end

  describe('create_assignment_override') do
    let(:createAssignmentOverrideUrl) { "courses/#{mockCourseId}/assignments/#{mockAssignmentId}/overrides" }

    before do
      stubs.post(
        createAssignmentOverrideUrl,
      ) { [200, {}, '{}'] }
    end

    it 'has correct request body' do
      expect(conn).to receive(:post).with(
        createAssignmentOverrideUrl,
        {
          student_ids: [mockStudentId],
          title:       mockTitle,
          due_at:      mockDate,
          unlock_at:   mockDate,
          lock_at:     mockDate,
        }
      )

      facade.create_assignment_override(
        mockCourseId,
        mockAssignmentId,
        [mockStudentId],
        mockTitle,
        mockDate,
        mockDate,
        mockDate,
      )
    end

    it 'has correct response body on successful call' do
      expect(facade.create_assignment_override(
        mockCourseId,
        mockAssignmentId,
        [mockStudentId],
        mockTitle,
        mockDate,
        mockDate,
        mockDate,
      ).body).to eq('{}')
      stubs.verify_stubbed_calls
    end
  end

  describe('update_assignment_override') do
    let(:updateAssignmentOverrideUrl) {
      "courses/#{mockCourseId}/assignments/#{mockAssignmentId}/overrides/#{mockOverrideId}"
    }
    before do
      stubs.put(
        updateAssignmentOverrideUrl,
      ) { [200, {}, '{}'] }
    end

    it 'has correct request body' do
      expect(conn).to receive(:put).with(
        updateAssignmentOverrideUrl,
        {
          student_ids: [mockStudentId],
          title:       mockTitle,
          due_at:      mockDate,
          unlock_at:   mockDate,
          lock_at:     mockDate,
        }
      )

      facade.update_assignment_override(
        mockCourseId,
        mockAssignmentId,
        mockOverrideId,
        [mockStudentId],
        mockTitle,
        mockDate,
        mockDate,
        mockDate,
      )
    end

    it 'has correct response body on successful call' do
      expect(facade.update_assignment_override(
        mockCourseId,
        mockAssignmentId,
        mockOverrideId,
        [mockStudentId],
        mockTitle,
        mockDate,
        mockDate,
        mockDate,
      ).body).to eq('{}')
      stubs.verify_stubbed_calls
    end
  end

  describe('delete_assignment_override') do
    before do
      stubs.delete(
        "courses/#{mockCourseId}/assignments/#{mockAssignmentId}/overrides/#{mockOverrideId}"
      ) { [200, {}, '{}'] }
    end

    it 'has correct response body on successful call' do
      expect(facade.delete_assignment_override(
        mockCourseId,
        mockAssignmentId,
        mockOverrideId
      ).body).to eq('{}')
      stubs.verify_stubbed_calls
    end
  end

  describe('provision_extension') do
    let(:mockOverrideCreationUrl) { "courses/#{mockCourseId}/assignments/#{mockAssignmentId}/overrides" }
    let(:mockCreationErrorResponseAlreadyExists) { [
      400,
      {},
      { errors: { assignment_override_students: [{
        attribute: 'assignment_override_students',
        type:      'taken',
        message:   'already belongs to an assignment override'
      }] } }.to_json
    ] }

    before do
      allow(facade).to receive(:get_current_formatted_time).and_return(mockDate)
    end

    it 'returns correct response body on successful creation' do
      stubs.post(mockOverrideCreationUrl) { [200, {}, '{}' ] }
      expect(facade.provision_extension(
        mockCourseId,
        mockStudentId,
        mockAssignmentId,
        mockDate
      ).body).to eq('{}')
    end

    it 'throws a pipeline error if the creation response body is improperly formatted' do
      stubs.post(mockOverrideCreationUrl) { [400, {}, '{invalid json}'] }
      expect { facade.provision_extension(
        mockCourseId,
        mockStudentId,
        mockAssignmentId,
        mockDate
      ) }.to raise_error(FailedPipelineError)
    end

    it 'throws an error if the existing override cannot be found' do
      stubs.post(mockOverrideCreationUrl) { mockCreationErrorResponseAlreadyExists }
      expect(facade).to receive(:get_existing_student_override).and_return(nil)
      expect { facade.provision_extension(
        mockCourseId,
        mockStudentId,
        mockAssignmentId,
        mockDate,
      ) }.to raise_error(NotFoundError)
    end

    it 'updates the existing assignment override if the student is the only student the override is provisioned to' do
      stubs.post(mockOverrideCreationUrl) { mockCreationErrorResponseAlreadyExists }
      expect(facade).to receive(:get_existing_student_override).and_return(OpenStruct.new(mockOverride))
      expect(facade).to receive(:update_assignment_override).with(
        mockCourseId,
        mockAssignmentId,
        mockOverride[:id],
        mockOverride[:student_ids],
        "#{mockStudentId} extended to #{mockDate}",
        mockDate,
        mockDate,
        mockDate,
      )
      facade.provision_extension(
        mockCourseId,
        mockStudentId,
        mockAssignmentId,
        mockDate,
      )
    end

    it 'creates a new override if the student\'s existing one has multiple other students' do
      mockOverride[:student_ids].append(mockStudentId + 1)
      stubs.post(mockOverrideCreationUrl) { mockCreationErrorResponseAlreadyExists }
      mockOverrideStruct = OpenStruct.new(mockOverride)
      expect(facade).to receive(:get_existing_student_override).and_return(mockOverrideStruct)
      expect(facade).to receive(:remove_student_from_override).with(
        mockCourseId,
        mockOverrideStruct,
        mockStudentId,
      )
      facade.provision_extension(
        mockCourseId,
        mockStudentId,
        mockAssignmentId,
        mockDate,
      )
    end
  end

  describe 'get_existing_student_override' do
    let(:getAssignmentOverridesUrl) { "courses/#{mockCourseId}/assignments/#{mockAssignmentId}/overrides" }
    it 'throws an error if the overrides response body cannot be parsed' do
      stubs.get(getAssignmentOverridesUrl) { [200, {}, '{invalid json}'] }
      expect { facade.send(
        :get_existing_student_override,
        mockCourseId,
        mockStudentId,
        mockAssignmentId
      ) }.to raise_error(FailedPipelineError)
    end

    it 'returns the override that the student is listed in' do
      mockOverrideWithoutStudent = mockOverride.clone
      mockOverrideWithoutStudent[:student_ids] = [mockStudentId + 1]
      stubs.get(getAssignmentOverridesUrl) { [
        200,
        {},
        [mockOverrideWithoutStudent, mockOverride].to_json,
      ] }
      expect(facade.send(
        :get_existing_student_override,
        mockCourseId,
        mockStudentId,
        mockAssignmentId
      ).student_ids[0]).to eq(mockStudentId)
    end

    it 'returns nil if no override for that student is found' do
      mockOverride[:student_ids] = [mockStudentId + 1]
      stubs.get(getAssignmentOverridesUrl) { [
        200,
        {},
        mockOverride.to_json
      ] }
      expect(facade.send(
        :get_existing_student_override,
        mockCourseId,
        mockStudentId,
        mockAssignmentId
      )).to eq(nil)
    end
  end

  describe 'get_current_formatted_time' do
    before do
      Timecop.freeze(DateTime.new(2002, 03, 16, 16))
    end

    it 'outputs the current time in Canvas iso8601 formatting' do
      expect(facade.send(:get_current_formatted_time)).to eq('2002-03-16T16:00:00Z')
    end
  end

  describe 'remove_student_from_override' do
    let(:mockOverrideStruct) { OpenStruct.new(mockOverride) }

    before do
      mockOverrideStruct.student_ids.append(mockStudentId + 1)
    end

    it 'removes the student and keeps everything else the same' do
      mockOverrideWithoutStudent = OpenStruct.new(mockOverride)
      mockOverrideWithoutStudent.student_ids = [mockStudentId + 1]
      expect(facade).to receive(:update_assignment_override).with(
        mockCourseId,
        mockOverrideStruct.assignment_id,
        mockOverrideStruct.id,
        mockOverrideStruct.student_ids,
        mockOverrideStruct.title,
        mockOverrideStruct.due_at,
        mockOverrideStruct.unlock_at,
        mockOverrideStruct.lock_at,
      ).and_return(OpenStruct.new({ body: mockOverrideWithoutStudent.to_h.to_json }))
      expect(facade.send(
        :remove_student_from_override,
        mockCourseId,
        mockOverrideStruct,
        mockStudentId
      ))
    end

    it 'throws a pipeline error if the student cannot be removed from the override' do
      expect(facade).to receive(:update_assignment_override).with(
        mockCourseId,
        mockOverrideStruct.assignment_id,
        mockOverrideStruct.id,
        mockOverrideStruct.student_ids,
        mockOverrideStruct.title,
        mockOverrideStruct.due_at,
        mockOverrideStruct.unlock_at,
        mockOverrideStruct.lock_at,
      ).and_return(OpenStruct.new({ body: mockOverrideStruct.to_h.to_json }))
      expect { facade.send(
        :remove_student_from_override,
        mockCourseId,
        mockOverrideStruct,
        mockStudentId
      ) }.to raise_error(FailedPipelineError)
    end
  end
end
