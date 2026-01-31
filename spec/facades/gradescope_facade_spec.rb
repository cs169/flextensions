require 'rails_helper'

describe GradescopeFacade do
  let(:facade) { described_class.new }
  let(:course_id) { '123456' }
  let(:assignment_id) { '789012' }
  let(:student_id) { '111222' }
  let(:student_email) { 'student@example.com' }
  let(:new_due_date) { '2025-12-31T23:59:59Z' }
  let(:mock_client) { instance_double(Lmss::Gradescope::Client) }
  let(:gradescope_email) { 'test@example.com' }
  let(:gradescope_password) { 'test_password' }

  before do
    # Stub environment variables for Gradescope credentials
    allow(ENV).to receive(:fetch).with('GRADESCOPE_EMAIL').and_return(gradescope_email)
    allow(ENV).to receive(:fetch).with('GRADESCOPE_PASSWORD').and_return(gradescope_password)
    allow(ENV).to receive(:fetch).with('GRADESCOPE_URL', 'https://www.gradescope.com').and_call_original
  end

  describe '#initialize' do
    it 'sets api_token and gradescope_conn to nil during initialization' do
      # GradescopeFacade does not use api_token, so it should be nil
      expect(facade.instance_variable_get(:@api_token)).to be_nil
      expect(facade.instance_variable_get(:@gradescope_conn)).to be_nil
    end
  end

  describe '.from_user' do
    it 'returns a new instance without requiring a user' do
      result = described_class.from_user
      expect(result).to be_a(described_class)
    end

    it 'ignores the user parameter as it is for compatibility' do
      user = Object.new
      result = described_class.from_user(user)
      expect(result).to be_a(described_class)
    end
  end

  describe '#get_all_assignments' do
    let(:html_response) {
      '<html><div data-react-class="AssignmentsTable" data-react-props=\'{"table_data":[]}\' /></html>'
    }
    let(:assignments_data) do
      [
        {
          'id' => 'assignment_789012',
          'title' => 'Homework 1',
          'submission_window' => {
            'due_date' => '2025-11-30T23:59:59Z',
            'hard_due_date' => '2025-12-02T23:59:59Z'
          }
        },
        {
          'id' => 'assignment_345678',
          'title' => 'Homework 2',
          'submission_window' => {
            'due_date' => '2025-12-15T23:59:59Z',
            'hard_due_date' => '2025-12-17T23:59:59Z'
          }
        }
      ]
    end
    let(:html_with_data) do
      props = { 'table_data' => assignments_data }.to_json
      "<html><div data-react-class=\"AssignmentsTable\" data-react-props='#{props}' /></html>"
    end

    before do
      allow(Lmss::Gradescope::Client).to receive(:new).and_return(mock_client)
    end

    context 'when authenticated successfully' do
      before do
        allow(mock_client).to receive(:get).with("/courses/#{course_id}/assignments").and_return(html_with_data)
        allow(mock_client).to receive(:extract_react_props).and_return({ 'table_data' => assignments_data })
      end

      it 'authenticates before fetching assignments' do
        expect(Lmss::Gradescope::Client).to receive(:new).with(gradescope_email, gradescope_password)
        facade.get_all_assignments(course_id)
      end

      it 'fetches assignments from the correct URL' do
        facade.instance_variable_set(:@gradescope_conn, mock_client)
        expect(mock_client).to receive(:get).with("/courses/#{course_id}/assignments")
        facade.get_all_assignments(course_id)
      end

      it 'extracts React props from HTML response' do
        facade.instance_variable_set(:@gradescope_conn, mock_client)
        expect(mock_client).to receive(:extract_react_props).with(html_with_data, 'AssignmentsTable')
        facade.get_all_assignments(course_id)
      end

      it 'returns an array of Assignment objects' do
        facade.instance_variable_set(:@gradescope_conn, mock_client)
        result = facade.get_all_assignments(course_id)
        expect(result).to all(be_a(Lmss::Gradescope::Assignment))
        expect(result.length).to eq(2)
      end

      it 'correctly parses assignment data' do
        facade.instance_variable_set(:@gradescope_conn, mock_client)
        result = facade.get_all_assignments(course_id)
        expect(result.first.id).to eq(789012)
        expect(result.first.name).to eq('Homework 1')
        expect(result.last.id).to eq(345678)
        expect(result.last.name).to eq('Homework 2')
      end
    end

    context 'when HTML response is blank' do
      before do
        allow(mock_client).to receive(:get).and_return(nil)
        facade.instance_variable_set(:@gradescope_conn, mock_client)
      end

      it 'logs returns empty array' do
        expect(Rails.logger).to receive(:error).with(/Failed to fetch assignments: No response/)
        result = facade.get_all_assignments(course_id)
        expect(result).to eq([])
      end
    end

    context 'when React props are missing' do
      before do
        allow(mock_client).to receive_messages(get: html_response, extract_react_props: nil)
        facade.instance_variable_set(:@gradescope_conn, mock_client)
      end

      it 'returns empty array' do
        result = facade.get_all_assignments(course_id)
        expect(result).to eq([])
      end
    end

    context 'when authentication fails' do
      before do
        allow(mock_client).to receive(:get).and_raise(Lmss::Gradescope::AuthenticationError, 'Login failed')
        facade.instance_variable_set(:@gradescope_conn, mock_client)
      end

      it 'logs error and raises authentication error' do
        expect(Rails.logger).to receive(:error).with(/Authentication failed: Login failed/)
        expect do
          facade.get_all_assignments(course_id)
        end.to raise_error(Lmss::Gradescope::AuthenticationError)
      end
    end

    context 'when a general error occurs' do
      before do
        allow(mock_client).to receive(:get).and_raise(StandardError, 'Network error')
        facade.instance_variable_set(:@gradescope_conn, mock_client)
      end

      it 'logs error and returns empty array' do
        expect(Rails.logger).to receive(:error).with(/Failed to fetch Gradescope assignments: Network error/)
        result = facade.get_all_assignments(course_id)
        expect(result).to eq([])
      end
    end
  end

  describe '#get_assignment_overrides' do
    let(:html_response) {
      '<html><div data-react-class="EditExtension" data-react-props=\'{}\' /></html>'
    }
    let(:overrides_data) do
      [
        {
          'deletePath' => '/courses/123/assignments/789/extensions/1',
          'override' => {
            'user_id' => student_id,
            'settings' => {
              'release_date' => { 'value' => '2025-11-01T00:00:00Z' },
              'due_date' => { 'value' => '2025-12-01T23:59:59Z' },
              'hard_due_date' => { 'value' => '2025-12-03T23:59:59Z' }
            }
          }
        },
        {
          'deletePath' => '/courses/123/assignments/789/extensions/2',
          'override' => {
            'user_id' => '333444',
            'settings' => {
              'release_date' => { 'value' => '2025-11-01T00:00:00Z' },
              'due_date' => { 'value' => '2025-12-05T23:59:59Z' },
              'hard_due_date' => { 'value' => '2025-12-07T23:59:59Z' }
            }
          }
        }
      ]
    end

    before do
      allow(Lmss::Gradescope::Client).to receive(:new).and_return(mock_client)
      facade.instance_variable_set(:@gradescope_conn, mock_client)
    end

    context 'when fetching overrides successfully' do
      before do
        allow(mock_client).to receive(:get).with("/courses/#{course_id}/assignments/#{assignment_id}/extensions").and_return(html_response)
        allow(mock_client).to receive(:extract_all_react_props).and_return(overrides_data)
      end

      it 'fetches overrides from the correct URL' do
        expect(mock_client).to receive(:get).with("/courses/#{course_id}/assignments/#{assignment_id}/extensions")
        facade.get_assignment_overrides(course_id, assignment_id)
      end

      it 'extracts all React props from HTML' do
        expect(mock_client).to receive(:extract_all_react_props).with(html_response, 'EditExtension')
        facade.get_assignment_overrides(course_id, assignment_id)
      end

      it 'returns an array of Override objects' do
        result = facade.get_assignment_overrides(course_id, assignment_id)
        expect(result).to all(be_a(Lmss::Gradescope::Override))
        expect(result.length).to eq(2)
      end

      it 'correctly parses override data' do
        result = facade.get_assignment_overrides(course_id, assignment_id)
        expect(result.first.student_id).to eq(student_id)
        expect(result.first.id).to eq(1)
        expect(result.last.student_id).to eq('333444')
        expect(result.last.id).to eq(2)
      end
    end

    context 'when HTML response is blank' do
      before do
        allow(mock_client).to receive(:get).and_return(nil)
      end

      it 'logs error and returns empty array' do
        expect(Rails.logger).to receive(:error).with(/Failed to fetch assignment extensions: No response/)
        result = facade.get_assignment_overrides(course_id, assignment_id)
        expect(result).to eq([])
      end
    end

    context 'when React props are missing' do
      before do
        allow(mock_client).to receive_messages(get: html_response, extract_all_react_props: nil)
      end

      it 'returns empty array' do
        result = facade.get_assignment_overrides(course_id, assignment_id)
        expect(result).to eq([])
      end
    end

    context 'when an error occurs' do
      before do
        allow(mock_client).to receive(:get).and_raise(StandardError, 'Network error')
      end

      it 'logs error and returns empty array' do
        expect(Rails.logger).to receive(:error).with(/Failed to fetch assignment extensions: Network error/)
        result = facade.get_assignment_overrides(course_id, assignment_id)
        expect(result).to eq([])
      end
    end
  end

  describe '#get_existing_student_override' do
    let(:first_override) do
      instance_double(Lmss::Gradescope::Override, student_id: student_id, id: 1)
    end
    let(:second_override) do
      instance_double(Lmss::Gradescope::Override, student_id: '999888', id: 2)
    end

    before do
      allow(Lmss::Gradescope::Client).to receive(:new).and_return(mock_client)
      facade.instance_variable_set(:@gradescope_conn, mock_client)
      allow(facade).to receive(:get_assignment_overrides).and_return([ first_override, second_override ])
    end

    it 'calls get_assignment_overrides' do
      expect(facade).to receive(:get_assignment_overrides).with(course_id, assignment_id)
      facade.get_existing_student_override(course_id, assignment_id, student_id)
    end

    it 'returns the override for the specified student' do
      result = facade.get_existing_student_override(course_id, assignment_id, student_id)
      expect(result).to eq(first_override)
      expect(result.student_id).to eq(student_id)
    end

    it 'returns nil when student has no override' do
      result = facade.get_existing_student_override(course_id, assignment_id, 'nonexistent')
      expect(result).to be_nil
    end
  end

  describe '#provision_extension' do
    let(:html_response) { '<html><div data-react-class="AddExtension" data-react-props=\'{}\' /></html>' }
    let(:students_data) do
      {
        'students' => [
          { 'id' => student_id, 'email' => student_email, 'name' => 'Test Student' },
          { 'id' => '999888', 'email' => 'other@example.com', 'name' => 'Other Student' }
        ]
      }
    end
    let(:html_with_students) do
      props = students_data.to_json
      "<html><div data-react-class=\"AddExtension\" data-react-props='#{props}' /></html>"
    end
    let(:created_override) do
      instance_double(Lmss::Gradescope::Override, student_id: student_id, id: 123)
    end

    before do
      allow(Lmss::Gradescope::Client).to receive(:new).and_return(mock_client)
      facade.instance_variable_set(:@gradescope_conn, mock_client)
    end

    context 'when provisioning extension successfully' do
      before do
        allow(mock_client).to receive_messages(get: html_with_students, extract_react_props: students_data, post: nil)
        allow(facade).to receive(:get_existing_student_override).and_return(created_override)
      end

      it 'fetches the extensions page' do
        expect(mock_client).to receive(:get).with("/courses/#{course_id}/assignments/#{assignment_id}/extensions")
        facade.provision_extension(course_id, student_email, assignment_id, new_due_date)
      end

      it 'extracts student data from React props' do
        expect(mock_client).to receive(:extract_react_props).with(html_with_students, 'AddExtension')
        facade.provision_extension(course_id, student_email, assignment_id, new_due_date)
      end

      it 'posts extension with correct payload' do
        expected_payload = {
          'override' => {
            'user_id' => student_id,
            'settings' => {
              'due_date' => {
                'type' => 'absolute',
                'value' => new_due_date
              },
              'hard_due_date' => {
                'type' => 'absolute',
                'value' => new_due_date
              }
            },
            'visible' => true
          }
        }
        expect(mock_client).to receive(:post).with(
          "/courses/#{course_id}/assignments/#{assignment_id}/extensions",
          expected_payload
        )
        facade.provision_extension(course_id, student_email, assignment_id, new_due_date)
      end

      it 'verifies extension creation' do
        expect(facade).to receive(:get_existing_student_override).with(course_id, assignment_id, student_id)
        facade.provision_extension(course_id, student_email, assignment_id, new_due_date)
      end

      it 'returns the created override' do
        result = facade.provision_extension(course_id, student_email, assignment_id, new_due_date)
        expect(result).to eq(created_override)
      end
    end

    context 'when new_due_date is nil' do
      before do
        allow(mock_client).to receive_messages(get: html_with_students, extract_react_props: students_data, post: nil)
        allow(facade).to receive(:get_existing_student_override).and_return(created_override)
      end

      it 'posts extension without date settings' do
        expected_payload = {
          'override' => {
            'user_id' => student_id,
            'settings' => {},
            'visible' => true
          }
        }
        expect(mock_client).to receive(:post).with(
          "/courses/#{course_id}/assignments/#{assignment_id}/extensions",
          expected_payload
        )
        facade.provision_extension(course_id, student_email, assignment_id, nil)
      end
    end

    context 'when HTML response is blank' do
      before do
        allow(mock_client).to receive(:get).and_return(nil)
      end

      it 'logs error and returns nil' do
        expect(Rails.logger).to receive(:error).with(/Failed to fetch assignment extensions: No response/)
        result = facade.provision_extension(course_id, student_email, assignment_id, new_due_date)
        expect(result).to be_nil
      end
    end

    context 'when React props are missing' do
      before do
        allow(mock_client).to receive_messages(get: html_response, extract_react_props: nil)
      end

      it 'returns nil' do
        result = facade.provision_extension(course_id, student_email, assignment_id, new_due_date)
        expect(result).to be_nil
      end
    end

    context 'when student email is not found' do
      before do
        allow(mock_client).to receive_messages(get: html_with_students, extract_react_props: students_data)
      end

      it 'logs error and returns nil' do
        expect(Rails.logger).to receive(:error).with(/Failed to fetch assignment extensions: Student nonexistent@example.com not found/)
        result = facade.provision_extension(course_id, 'nonexistent@example.com', assignment_id, new_due_date)
        expect(result).to be_nil
      end
    end

    context 'when extension creation cannot be verified' do
      before do
        allow(mock_client).to receive_messages(get: html_with_students, extract_react_props: students_data, post: nil)
        allow(facade).to receive(:get_existing_student_override).and_return(nil)
      end

      it 'logs error and returns nil' do
        expect(Rails.logger).to receive(:error).with(/Failed to verify extension creation for student #{student_email}/)
        result = facade.provision_extension(course_id, student_email, assignment_id, new_due_date)
        expect(result).to be_nil
      end
    end

    context 'when an error occurs during provisioning' do
      before do
        allow(mock_client).to receive(:get).and_raise(StandardError, 'Network error')
      end

      it 'logs error and raises exception' do
        expect(Rails.logger).to receive(:error).with(/Failed to provision extension: Network error/)
        expect do
          facade.provision_extension(course_id, student_email, assignment_id, new_due_date)
        end.to raise_error(StandardError, 'Network error')
      end
    end
  end

  describe '#ensure_authenticated!' do
    context 'when not yet authenticated' do
      it 'creates a new Gradescope client' do
        expect(Lmss::Gradescope::Client).to receive(:new).with(gradescope_email, gradescope_password).and_return(mock_client)
        facade.send(:ensure_authenticated!)
      end

      it 'sets the gradescope_conn instance variable' do
        allow(Lmss::Gradescope::Client).to receive(:new).and_return(mock_client)
        facade.send(:ensure_authenticated!)
        expect(facade.instance_variable_get(:@gradescope_conn)).to eq(mock_client)
      end

      it 'raises error if client creation fails' do
        allow(Lmss::Gradescope::Client).to receive(:new).and_return(nil)
        expect do
          facade.send(:ensure_authenticated!)
        end.to raise_error(GradescopeFacade::GradescopeAPIError, 'Failed to authenticate to Gradescope')
      end
    end

    context 'when already authenticated' do
      before do
        facade.instance_variable_set(:@gradescope_conn, mock_client)
      end

      it 'does not create a new client' do
        expect(Lmss::Gradescope::Client).not_to receive(:new)
        facade.send(:ensure_authenticated!)
      end
    end
  end
end
