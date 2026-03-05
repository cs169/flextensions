require 'date'
require 'json'
require 'ostruct'
require 'rails_helper'
require 'timecop'

describe CanvasFacade do
  let(:mock_auth_token) { 'testAuthToken' }
  let(:course_id) { 16 }
  let(:student_id) { 22 }
  let(:assignment_id) { 18 }
  let(:title) { 'mock_overrideTitle' }
  let(:mock_date) { '2002-03-16:16:00:00Z' }
  let(:override_id) { 8 }
  let(:mock_override) do
    {
      id: override_id,
      assignment_id: assignment_id,
      title: 'mock_override_title',
      due_at: mock_date,
      unlock_at: mock_date,
      lock_at: mock_date,
      student_ids: [ student_id ]
    }
  end

  let(:facade) { described_class.new(mock_auth_token, conn) }
  let(:conn) { Faraday.new { |builder| builder.adapter(:test, stubs) } }
  # Used https://danielabaron.me/blog/testing-faraday-with-rspec/ as reference.
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }

  # Allows each  test to have its own set of stubs.
  after do
    Faraday.default_connection = nil
  end

  describe '#get_assignments' do
    let(:external_course_id) { '123' }
    let(:assignments_response) do
      [
        {
          'id' => '456',
          'name' => 'Assignment 1',
          'due_at' => '2025-01-15T23:59:00Z',
          'all_dates' => [
            { 'base' => true, 'due_at' => '2025-01-15T23:59:00Z' },
            { 'base' => false, 'due_at' => '2025-01-20T23:59:00Z' }
          ]
        }
      ].to_json
    end

    before do
      stubs.get("courses/#{external_course_id}/assignments") do |env|
        [ 200, {}, assignments_response ]
      end
    end

    it 'makes a request with correct parameters' do
      result = facade.get_assignments(external_course_id)
      params = Rack::Utils.parse_query(URI(result.env.url).query)
      expect(params['include[]']).to eq('all_dates')
      expect(params['per_page']).to eq('100')
      expect(result.status).to eq(200)
      expect(result.body).to eq(assignments_response)
    end
  end

  describe '#get_all_assignments' do
    let(:external_course_id) { '123' }
    let(:assignments_data) do
      [
        {
          'id' => '456',
          'name' => 'Assignment 1',
          'due_at' => '2025-01-15T23:59:00Z',
          'all_dates' => [
            { 'base' => true, 'due_at' => '2025-01-15T23:59:00Z', 'lock_at' => '2025-01-20T23:59:00Z' },
            { 'base' => false, 'due_at' => '2025-01-20T23:59:00Z', 'lock_at' => '2025-01-25T23:59:00Z' }
          ]
        },
        {
          'id' => '789',
          'name' => 'Assignment 2',
          'due_at' => '2025-02-15T23:59:00Z',
          'all_dates' => []
        }
      ]
    end

    before do
      allow(facade).to receive_messages(
        get_assignments: instance_double(Faraday::Response),
        depaginate_response: assignments_data
      )
    end

    it 'calls get_assignments and depaginate_response' do
      facade.get_all_assignments(external_course_id)

      expect(facade).to have_received(:get_assignments).with(external_course_id)
      expect(facade).to have_received(:depaginate_response)
    end

    it 'processes assignments to extract base dates' do
      result = facade.get_all_assignments(external_course_id)

      expect(result.first.due_date).to eq(DateTime.parse('2025-01-15T23:59:00Z'))
      expect(result.first.late_due_date).to eq(DateTime.parse('2025-01-20T23:59:00Z'))
      expect(result.second.due_date).to eq(DateTime.parse('2025-02-15T23:59:00Z'))
      expect(result.second.late_due_date).to be_nil
    end

    it 'returns all assignments as Lmss objects' do
      result = facade.get_all_assignments(external_course_id)

      expect(result).to all(be_a(Lmss::Canvas::Assignment))
      expect(result.map(&:id)).to contain_exactly('456', '789')
    end

    context 'when assignment has no all_dates' do
      let(:assignments_data) do
        [
          {
            'id' => '999',
            'name' => 'Assignment without all_dates',
            'due_at' => '2025-03-15T23:59:00Z'
          }
        ]
      end

      it 'falls back to top-level due_at when base dates missing' do
        result = facade.get_all_assignments(external_course_id)

        expect(result.first.due_date).to eq(DateTime.parse('2025-03-15T23:59:00Z'))
        expect(result.first.late_due_date).to be_nil
      end
    end
  end

  describe('initialization') do
    it 'sets the proper URL' do
      expect(Faraday).to receive(:new).with(hash_including(
                                              url: "#{ENV.fetch('CANVAS_URL', nil)}/api/v1"
                                            ))
      described_class.new(mock_auth_token)
    end

    it 'sets the proper token' do
      expect(Faraday).to receive(:new).with(hash_including(
                                              headers: {
                                                Authorization: "Bearer #{mock_auth_token}"
                                              }
                                            ))
      described_class.new(mock_auth_token)
    end
  end

  # NOTE: 2025-08: This method does not return a faraday class.
  # other methods need to be refactors too.
  describe 'get_all_courses' do
    before do
      stubs.get('courses') { [ 200, {}, '[]' ] }
    end

    it 'has correct response body on successful call' do
      expect(facade.get_all_courses).to eq([])
      stubs.verify_stubbed_calls
    end
  end

  describe 'get_course' do
    before do
      stubs.get("courses/#{course_id}") { [ 200, {}, '{}' ] }
    end

    it 'has correct response body on successful call' do
      expect(facade.get_course(course_id).body).to eq('{}')
      stubs.verify_stubbed_calls
    end
  end

  describe('get_assignments') do
    before do
      stubs.get("courses/#{course_id}/assignments") { [ 200, {}, '{}' ] }
    end

    it 'has correct response body on successful call' do
      expect(facade.get_assignments(course_id).body).to eq('{}')
      stubs.verify_stubbed_calls
    end
  end

  describe('get_assignment') do
    before do
      stubs.get("courses/#{course_id}/assignments/#{assignment_id}") { [ 200, {}, '{}' ] }
    end

    it 'has correct response body on successful call' do
      expect(facade.get_assignment(course_id, assignment_id).body).to eq('{}')
      stubs.verify_stubbed_calls
    end
  end

  describe('get_assignment_overrides') do
    before do
      stubs.get(
        "courses/#{course_id}/assignments/#{assignment_id}/overrides"
      ) { [ 200, {}, '{}' ] }
    end

    it 'has correct response body on successful call' do
      expect(facade.get_assignment_overrides(course_id, assignment_id).body).to eq('{}')
      stubs.verify_stubbed_calls
    end
  end

  describe('create_assignment_override') do
    let(:create_assignment_override_url) { "courses/#{course_id}/assignments/#{assignment_id}/overrides" }

    before do
      stubs.post(
        create_assignment_override_url
      ) { [ 200, {}, '{}' ] }
    end

    it 'has correct request body' do
      expect(conn).to receive(:post).with(
        create_assignment_override_url,
        { assignment_override: {
          student_ids: [ student_id ],
          title: title,
          due_at: mock_date,
          unlock_at: mock_date,
          lock_at: mock_date
        } }
      )

      facade.create_assignment_override(
        course_id,
        assignment_id,
        [ student_id ],
        title,
        mock_date,
        mock_date,
        mock_date
      )
    end

    it 'has correct response body on successful call' do
      expect(facade.create_assignment_override(
        course_id,
        assignment_id,
        [ student_id ],
        title,
        mock_date,
        mock_date,
        mock_date
      ).body).to eq('{}')
      stubs.verify_stubbed_calls
    end
  end

  describe('update_assignment_override') do
    let(:update_assignment_overrid_url) do
      "courses/#{course_id}/assignments/#{assignment_id}/overrides/#{override_id}"
    end

    before do
      stubs.put(
        update_assignment_overrid_url
      ) { [ 200, {}, '{}' ] }
    end

    it 'has correct request body' do
      expect(conn).to receive(:put).with(
        update_assignment_overrid_url,
        {
          student_ids: [ student_id ],
          title: title,
          due_at: mock_date,
          unlock_at: mock_date,
          lock_at: mock_date
        }
      )

      facade.update_assignment_override(
        course_id,
        assignment_id,
        override_id,
        [ student_id ],
        title,
        mock_date,
        mock_date,
        mock_date
      )
    end

    it 'has correct response body on successful call' do
      expect(facade.update_assignment_override(
        course_id,
        assignment_id,
        override_id,
        [ student_id ],
        title,
        mock_date,
        mock_date,
        mock_date
      ).body).to eq('{}')
      stubs.verify_stubbed_calls
    end
  end

  describe('delete_assignment_override') do
    before do
      stubs.delete(
        "courses/#{course_id}/assignments/#{assignment_id}/overrides/#{override_id}"
      ) { [ 200, {}, '{}' ] }
    end

    it 'has correct response body on successful call' do
      expect(facade.delete_assignment_override(
        course_id,
        assignment_id,
        override_id
      ).body).to eq('{}')
      stubs.verify_stubbed_calls
    end
  end

  describe('provision_extension') do
    let(:mock_override_creation_url) { "courses/#{course_id}/assignments/#{assignment_id}/overrides" }
    let(:create_success_response) { instance_double(Faraday::Response, status: 200, body: '{}') }
    let(:create_invalid_json_response) { instance_double(Faraday::Response, status: 400, body: '{invalid json}') }
    let(:create_taken_response) { instance_double(Faraday::Response, status: 400, body: creation_error_response_already_exists[2]) }
    let(:creation_error_response_already_exists) do
      [
        400,
        {},
        { errors: { assignment_override_students: [ {
          attribute: 'assignment_override_students',
          type: 'taken',
          message: 'already belongs to an assignment override'
        } ] } }.to_json
      ]
    end

    before do
      allow(facade).to receive(:delete_assignment_override)
      allow(facade).to receive_messages(get_current_formatted_time: mock_date, get_existing_student_override: nil, create_assignment_override: create_success_response)
    end

    it 'returns correct response body on successful creation' do
      result = facade.provision_extension(
        course_id,
        student_id,
        assignment_id,
        mock_date
      )

      expect(result).to be_a(Lmss::Canvas::Override)
    end

    it 'passes nil for close_date (lock_at) when late due date is not provided' do
      expect(facade).to receive(:create_assignment_override).with(
        course_id, assignment_id, [ student_id ],
        "#{student_id} extended to #{mock_date}",
        mock_date, mock_date, nil
      ).and_return(create_success_response)

      facade.provision_extension(
        course_id,
        student_id,
        assignment_id,
        mock_date
      )
    end

    it 'uses the close_date (late due date) for lock_at when provided' do
      close_date = '2002-03-20T16:00:00Z'
      expect(facade).to receive(:create_assignment_override).with(
        course_id, assignment_id, [ student_id ],
        "#{student_id} extended to #{mock_date}",
        mock_date, mock_date, close_date
      ).and_return(create_success_response)

      facade.provision_extension(
        course_id,
        student_id,
        assignment_id,
        mock_date,
        close_date
      )
    end

    it 'throws a pipeline error if the creation response body is improperly formatted' do
      allow(facade).to receive(:create_assignment_override).and_return(create_invalid_json_response)
      expect do
        facade.provision_extension(
          course_id,
          student_id,
          assignment_id,
          mock_date
        )
      end.to raise_error(FailedPipelineError)
    end

    it 'throws an error if the existing override cannot be found' do
      allow(facade).to receive_messages(create_assignment_override: create_taken_response, get_existing_student_override: nil)
      expect do
        facade.provision_extension(
          course_id,
          student_id,
          assignment_id,
          mock_date
        )
      end.to raise_error(NotFoundError)
    end

    it 'updates the existing assignment override if the student is the only student the override is provisioned to' do
      allow(facade).to receive(:create_assignment_override).and_return(create_taken_response)
      allow(facade).to receive(:create_assignment_override).and_return(create_taken_response)
      expect(facade).to receive(:get_existing_student_override).twice.and_return(OpenStruct.new(mock_override))
      expect(facade).to receive(:update_assignment_override).with(
        course_id,
        assignment_id,
        mock_override[:id],
        mock_override[:student_ids],
        "#{student_id} extended to #{mock_date}",
        mock_date,
        mock_date,
        nil
      ).and_return(instance_double(Faraday::Response, body: '{}'))
      facade.provision_extension(
        course_id,
        student_id,
        assignment_id,
        mock_date
      )
    end

    it 'passes close_date to update when updating existing override' do
      close_date = '2002-03-20T16:00:00Z'
      allow(facade).to receive(:create_assignment_override).and_return(create_taken_response)
      expect(facade).to receive(:get_existing_student_override).twice.and_return(OpenStruct.new(mock_override))
      expect(facade).to receive(:update_assignment_override).with(
        course_id,
        assignment_id,
        mock_override[:id],
        mock_override[:student_ids],
        "#{student_id} extended to #{mock_date}",
        mock_date,
        mock_date,
        close_date
      ).and_return(instance_double(Faraday::Response, body: '{}'))
      facade.provision_extension(
        course_id,
        student_id,
        assignment_id,
        mock_date,
        close_date
      )
    end

    it 'creates a new override if the student\'s existing one has multiple other students' do
      mock_override[:student_ids].append(student_id + 1)
      mock_override_struct = OpenStruct.new(mock_override)
      allow(facade).to receive(:create_assignment_override).and_return(create_taken_response, create_success_response)
      expect(facade).to receive(:get_existing_student_override).twice.and_return(mock_override_struct)
      expect(facade).to receive(:remove_student_from_override).with(
        course_id,
        mock_override_struct,
        student_id
      ).and_return(instance_double(Faraday::Response, body: '{}'))
      facade.provision_extension(
        course_id,
        student_id,
        assignment_id,
        mock_date
      )
    end
  end

  describe 'get_existing_student_override' do
    let(:get_assignment_overrides_url) { "courses/#{course_id}/assignments/#{assignment_id}/overrides" }

    it 'throws an error if the overrides response body cannot be parsed' do
      stubs.get(get_assignment_overrides_url) { [ 200, {}, '{invalid json}' ] }
      expect do
        facade.send(
          :get_existing_student_override,
          course_id,
          student_id,
          assignment_id
        )
      end.to raise_error(FailedPipelineError)
    end

    it 'returns the override that the student is listed in' do
      mock_overrideWithoutStudent = mock_override.clone
      mock_overrideWithoutStudent[:student_ids] = [ student_id + 1 ]
      stubs.get(get_assignment_overrides_url) do
        [
          200,
          {},
          [ mock_overrideWithoutStudent, mock_override ].to_json
        ]
      end
      expect(facade.send(
        :get_existing_student_override,
        course_id,
        student_id,
        assignment_id
      ).student_ids[0]).to eq(student_id)
    end

    it 'returns nil if no override for that student is found' do
      mock_override[:student_ids] = [ student_id + 1 ]
      stubs.get(get_assignment_overrides_url) do
        [
          200,
          {},
          mock_override.to_json
        ]
      end
      expect(facade.send(
               :get_existing_student_override,
               course_id,
               student_id,
               assignment_id
             )).to be_nil
    end

    it 'skips overrides with nil student_ids' do
      mock_override_nil_students = mock_override.clone
      mock_override_nil_students[:student_ids] = nil
      stubs.get(get_assignment_overrides_url) do
        [
          200,
          {},
          [ mock_override_nil_students, mock_override ].to_json
        ]
      end
      expect(facade.send(
               :get_existing_student_override,
               course_id,
               student_id,
               assignment_id
             ).student_ids[0]).to eq(student_id)
    end
  end

  describe 'get_current_formatted_time' do
    before do
      Timecop.freeze(DateTime.new(2002, 0o3, 16, 16))
    end

    it 'outputs the current time in Canvas iso8601 formatting' do
      expect(facade.send(:get_current_formatted_time)).to eq('2002-03-16T16:00:00Z')
    end
  end

  describe 'remove_student_from_override' do
    let(:mock_override_struct) { OpenStruct.new(mock_override) }

    before do
      mock_override_struct.student_ids.append(student_id + 1)
    end

    it 'removes the student and keeps everything else the same' do
      mock_overrideWithoutStudent = OpenStruct.new(mock_override)
      mock_overrideWithoutStudent.student_ids = [ student_id + 1 ]
      expect(facade).to receive(:update_assignment_override).with(
        course_id,
        mock_override_struct.assignment_id,
        mock_override_struct.id,
        mock_override_struct.student_ids,
        mock_override_struct.title,
        mock_override_struct.due_at,
        mock_override_struct.unlock_at,
        mock_override_struct.lock_at
      ).and_return(OpenStruct.new({ body: mock_overrideWithoutStudent.to_h.to_json }))
      expect(facade.send(
               :remove_student_from_override,
               course_id,
               mock_override_struct,
               student_id
             ))
    end

    it 'throws a pipeline error if the student cannot be removed from the override' do
      expect(facade).to receive(:update_assignment_override).with(
        course_id,
        mock_override_struct.assignment_id,
        mock_override_struct.id,
        mock_override_struct.student_ids,
        mock_override_struct.title,
        mock_override_struct.due_at,
        mock_override_struct.unlock_at,
        mock_override_struct.lock_at
      ).and_return(OpenStruct.new({ body: mock_override_struct.to_h.to_json }))
      expect do
        facade.send(
          :remove_student_from_override,
          course_id,
          mock_override_struct,
          student_id
        )
      end.to raise_error(FailedPipelineError)
    end
  end
end
