require 'rails_helper'

RSpec.describe Request, type: :model do
  let(:user) { User.create!(email: 'student@example.com', canvas_uid: '123', name: 'Student', student_id: 'S12345') }
  let(:instructor) { User.create!(email: 'instructor@example.com', canvas_uid: '456', name: 'Instructor') }
  let(:course) { Course.create!(course_name: 'Test Course', canvas_id: '789', course_code: 'TST101') }
  let(:course_to_lms) { CourseToLms.create!(course: course, lms_id: 1) }
  let(:assignment) do
    Assignment.create!(
      name: 'Assignment 1',
      course_to_lms_id: course_to_lms.id,
      external_assignment_id: 'ext1',
      enabled: true,
      due_date: 2.days.from_now
    )
  end
  let(:course_settings) do
    CourseSettings.create!(
      course: course,
      enable_extensions: true,
      auto_approve_days: 3,
      max_auto_approve: 2
    )
  end
  let(:request) do
    described_class.create!(
      user: user,
      course: course,
      assignment: assignment,
      reason: 'Need more time',
      requested_due_date: 4.days.from_now
    )
  end

  before do
    Lms.find_or_create_by(id: 1, lms_name: 'Canvas', use_auth_token: true)
    UserToCourse.create!(user: user, course: course, role: 'student')
    user.lms_credentials.create!(
      lms_name: 'canvas',
      token: 'fake_token',
      refresh_token: 'fake_refresh_token',
      expire_time: 1.hour.from_now
    )
  end

  describe 'validations' do
    it 'validates presence of requested_due_date' do
      request = described_class.new(reason: 'Test')
      expect(request.valid?).to be false
      expect(request.errors[:requested_due_date]).to include("can't be blank")
    end

    it 'validates presence of reason' do
      request = described_class.new(requested_due_date: 1.day.from_now)
      expect(request.valid?).to be false
      expect(request.errors[:reason]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to course' do
      expect(request.course).to eq(course)
    end

    it 'belongs to assignment' do
      expect(request.assignment).to eq(assignment)
    end

    it 'belongs to user' do
      expect(request.user).to eq(user)
    end

    it 'can belong to last_processed_by_user' do
      request.update(last_processed_by_user: instructor)
      expect(request.last_processed_by_user).to eq(instructor)
    end
  end

  describe '.merge_date_and_time!' do
    it 'combines date and time into a single datetime' do
      params = {
        requested_due_date: '2023-05-15',
        due_time: '14:30'
      }

      described_class.merge_date_and_time!(params)

      expect(params[:requested_due_date]).to be_a(Time)
      expect(params[:requested_due_date].strftime('%Y-%m-%d %H:%M')).to eq('2023-05-15 14:30')
    end

    it 'does nothing if requested_due_date is missing' do
      params = { due_time: '14:30' }
      original_params = params.dup

      described_class.merge_date_and_time!(params)

      expect(params).to eq(original_params)
    end

    it 'does nothing if due_time is missing' do
      params = { requested_due_date: '2023-05-15' }
      original_params = params.dup

      described_class.merge_date_and_time!(params)

      expect(params).to eq(original_params)
    end
  end

  describe '#calculate_days_difference' do
    it 'calculates the difference in days between requested due date and assignment due date' do
      request = described_class.new(
        requested_due_date: assignment.due_date + 3.days,
        assignment: assignment
      )

      expect(request.calculate_days_difference).to eq(3)
    end
  end

  describe '#auto_approval_eligible_for_course?' do
    context 'when course settings allow auto approval' do
      before { course_settings }

      it 'returns true' do
        expect(request.auto_approval_eligible_for_course?).to be true
      end
    end

    context 'when course settings do not exist' do
      before do
        # Ensure course settings don't exist
        course.course_settings&.destroy
      end

      it 'returns false' do
        # Add this line to debug
        expect(request.course.course_settings).to be_nil
        expect(request.auto_approval_eligible_for_course?).to be false
      end
    end

    context 'when extensions are disabled' do
      before do
        course_settings.update(enable_extensions: false)
      end

      it 'returns false' do
        expect(request.auto_approval_eligible_for_course?).to be false
      end
    end

    context 'when auto_approve_days is zero' do
      before do
        course_settings.update(auto_approve_days: 0)
      end

      it 'returns false' do
        expect(request.auto_approval_eligible_for_course?).to be false
      end
    end
  end

  describe '#eligible_for_auto_approval?' do
    before { course_settings }

    context 'when all conditions are met' do
      it 'returns true' do
        expect(request.eligible_for_auto_approval?).to be true
      end
    end

    context 'when course settings do not exist' do
      before do
        # Actually destroy the settings
        course.course_settings.destroy
        # Reload course to clear relationship cache
        course.reload
      end

      it 'returns false' do
        # Verify settings are gone
        expect(course.course_settings).to be_nil
        expect(request.eligible_for_auto_approval?).to be false
      end
    end

    context 'when auto_approve_days is zero' do
      before do
        course_settings.update(auto_approve_days: 0)
      end

      it 'returns false' do
        expect(request.eligible_for_auto_approval?).to be false
      end
    end

    context 'when requested extension is too long' do
      before do
        course_settings.update(auto_approve_days: 1)
      end

      it 'returns false' do
        expect(request.eligible_for_auto_approval?).to be false
      end
    end

    context 'when requested date is before assignment due date' do
      let(:early_request) do
        described_class.create!(
          user: user,
          course: course,
          assignment: assignment,
          reason: 'Need more time',
          requested_due_date: assignment.due_date - 1.day
        )
      end

      it 'returns false' do
        expect(early_request.eligible_for_auto_approval?).to be false
      end
    end

    context 'when user has reached max auto approvals' do
      before do
        course_settings.update(max_auto_approve: 1)
        # Create a previously approved request that was auto-approved
        described_class.create!(
          user: user,
          course: course,
          assignment: assignment,
          reason: 'Previous request',
          requested_due_date: 3.days.from_now,
          status: 'approved',
          auto_approved: true
        )
      end

      it 'returns false' do
        expect(request.eligible_for_auto_approval?).to be false
      end
    end

    context 'when max_auto_approve is zero (unlimited)' do
      before do
        course_settings.update(max_auto_approve: 0)
        # Create several previously approved requests
        3.times do |i|
          described_class.create!(
            user: user,
            course: course,
            assignment: assignment,
            reason: "Previous request #{i}",
            requested_due_date: 3.days.from_now,
            status: 'approved'
          )
        end
      end

      it 'returns true regardless of previous approvals' do
        expect(request.eligible_for_auto_approval?).to be true
      end
    end
  end

  describe '#try_auto_approval' do
    let(:canvas_facade) { instance_double(CanvasFacade) }

    before do
      course_settings
      allow(CanvasFacade).to receive(:new).and_return(canvas_facade)
    end

    context 'when auto approval is eligible and successful' do
      before do
        allow(request).to receive_messages(auto_approval_eligible_for_course?: true, eligible_for_auto_approval?: true, auto_approve: true)
      end

      it 'returns true' do
        expect(request.try_auto_approval(user)).to be true
      end

      it 'calls auto_approve with a canvas_facade' do
        expect(request).to receive(:auto_approve).with(canvas_facade)
        request.try_auto_approval(user)
      end
    end

    context 'when course is not eligible for auto approval' do
      before do
        allow(request).to receive(:auto_approval_eligible_for_course?).and_return(false)
      end

      it 'returns false' do
        expect(request.try_auto_approval(user)).to be false
      end

      it 'does not call auto_approve' do
        expect(request).not_to receive(:auto_approve)
        request.try_auto_approval(user)
      end
    end

    context 'when user has no LMS credentials' do
      before do
        allow(request).to receive(:auto_approval_eligible_for_course?).and_return(true)
        user.lms_credentials.destroy_all
      end

      it 'returns false' do
        expect(request.try_auto_approval(user)).to be false
      end
    end

    context 'when request is not eligible for auto approval' do
      before do
        allow(request).to receive_messages(auto_approval_eligible_for_course?: true, eligible_for_auto_approval?: false)
      end

      it 'returns false' do
        expect(request.try_auto_approval(user)).to be false
      end
    end
  end

  describe '#auto_approve' do
    let(:canvas_facade) { instance_double(CanvasFacade) }
    let(:system_user) { User.create!(email: 'system@example.com', canvas_uid: '789', name: 'System') }

    before do
      allow(SystemUserService).to receive(:auto_approval_user).and_return(system_user)
      allow(request).to receive_messages(eligible_for_auto_approval?: true, approve: true)
    end

    it 'calls approve with the system user' do
      expect(request).to receive(:approve).with(canvas_facade, system_user)
      request.auto_approve(canvas_facade)
    end

    it 'marks the request as auto-approved' do
      request.auto_approve(canvas_facade)
      expect(request.auto_approved).to be true
    end

    context 'when the system user does not exist yet' do
      before do
        allow(SystemUserService).to receive_messages(auto_approval_user: nil, ensure_auto_approval_user_exists: system_user)
      end

      it 'creates a system user' do
        expect(SystemUserService).to receive(:ensure_auto_approval_user_exists)
        request.auto_approve(canvas_facade)
      end
    end

    context 'when the request is not eligible for auto approval' do
      before do
        allow(request).to receive(:eligible_for_auto_approval?).and_return(false)
      end

      it 'returns false' do
        expect(request.auto_approve(canvas_facade)).to be false
      end

      it 'does not call approve' do
        expect(request).not_to receive(:approve)
        request.auto_approve(canvas_facade)
      end
    end

    context 'when no system user can be found or created' do
      before do
        allow(SystemUserService).to receive_messages(auto_approval_user: nil, ensure_auto_approval_user_exists: nil)
      end

      it 'returns false' do
        expect(request.auto_approve(canvas_facade)).to be false
      end
    end

    context 'when approve returns false' do
      before do
        allow(request).to receive(:approve).and_return(false)
      end

      it 'returns false' do
        expect(request.auto_approve(canvas_facade)).to be false
      end

      it 'does not mark the request as auto-approved' do
        request.auto_approve(canvas_facade)
        expect(request.auto_approved).to be_falsey
      end
    end
  end

  describe '#approve' do
    let(:canvas_facade) { instance_double(CanvasFacade) }
    let(:overrides_response) { instance_double(Faraday::Response, success?: true, body: [].to_json) }
    let(:create_response) { instance_double(Faraday::Response, success?: true, body: { 'id' => 'override-1' }.to_json) }

    before do
      allow(canvas_facade).to receive_messages(get_assignment_overrides: overrides_response, create_assignment_override: create_response)
    end

    it 'creates an override in Canvas' do
      expect(canvas_facade).to receive(:create_assignment_override).with(
        course.canvas_id,
        assignment.external_assignment_id,
        [user.canvas_uid],
        "Extension for #{user.name}",
        request.requested_due_date.iso8601,
        nil,
        nil
      )

      request.approve(canvas_facade, instructor)
    end

    it 'updates the request status to approved' do
      request.approve(canvas_facade, instructor)
      expect(request.status).to eq('approved')
    end

    it 'sets the last_processed_by_user_id' do
      request.approve(canvas_facade, instructor)
      expect(request.last_processed_by_user_id).to eq(instructor.id)
    end

    it 'sets the external_extension_id' do
      request.approve(canvas_facade, instructor)
      expect(request.external_extension_id).to eq('override-1')
    end

    context 'when an existing override exists' do
      let(:existing_override) { { 'id' => 'existing-override', 'student_ids' => [user.canvas_uid.to_s] } }
      let(:overrides_response) { instance_double(Faraday::Response, success?: true, body: [existing_override].to_json) }

      before do
        allow(canvas_facade).to receive(:delete_assignment_override).and_return(true)
      end

      it 'deletes the existing override first' do
        expect(canvas_facade).to receive(:delete_assignment_override).with(
          course.canvas_id,
          assignment.external_assignment_id,
          'existing-override'
        )

        request.approve(canvas_facade, instructor)
      end
    end

    context 'when creating the override fails' do
      let(:create_response) { instance_double(Faraday::Response, success?: false) }

      it 'returns false' do
        expect(request.approve(canvas_facade, instructor)).to be false
      end

      it 'does not update the request status' do
        request.approve(canvas_facade, instructor)
        expect(request.status).not_to eq('approved')
      end
    end
  end

  describe '#reject' do
    it 'updates the request status to denied' do
      request.reject(instructor)
      expect(request.status).to eq('denied')
    end

    it 'sets the last_processed_by_user_id' do
      request.reject(instructor)
      expect(request.last_processed_by_user_id).to eq(instructor.id)
    end
  end

  describe '#generate_email_response' do
    let(:course_settings) do
      CourseSettings.create!(
        course: course,
        enable_emails: true,
        email_subject: 'Extension {{status}} for {{assignment_name}}',
        email_template: <<~TEMPLATE
          Dear {{student_name}},

          Your extension request for {{assignment_name}} in {{course_name}} ({{course_code}}) has been {{status}}.

          Original due date: {{original_due_date}}
          New due date:      {{new_due_date}}
          Extension days:    {{extension_days}}
        TEMPLATE
      )
    end

    before do
      course_settings
      request.update(status: 'approved')
    end

    it 'generates email response with all placeholders replaced' do
      email_response = request.generate_email_response

      expect(email_response[:subject]).to eq("Extension Approved for #{assignment.name}")
      expect(email_response[:template]).to include("Dear #{user.name}")
      expect(email_response[:template]).to include(assignment.name)
      expect(email_response[:template]).to include(course.course_name)
      expect(email_response[:template]).to include(course.course_code)
      expect(email_response[:template]).to include('Approved')
      expect(email_response[:template]).to include(assignment.due_date.strftime('%a, %b %-d, %Y %-I:%M %p'))
      expect(email_response[:template]).to include(request.requested_due_date.strftime('%a, %b %-d, %Y %-I:%M %p'))
      expect(email_response[:template]).to include(request.calculate_days_difference.to_s)
    end

    it 'returns error message when course settings are not found' do
      course.course_settings = nil
      expect(request.generate_email_response).to eq('Course settings not found.')
    end
  end

  describe '#send_email_response' do
    let(:course_settings) do
      CourseSettings.create!(
        course: course,
        enable_emails: true,
        reply_email: 'instructor@example.com'
      )
    end

    before do
      course_settings
      allow(Rails.logger).to receive(:info)
    end

    it 'logs email details when sending email' do
      request.send_email_response

      expect(Rails.logger).to have_received(:info).with("Sending email to: #{user.email}")
      expect(Rails.logger).to have_received(:info).with("Sending email from: #{course_settings.reply_email}")
      expect(Rails.logger).to have_received(:info).with(/Request email subject:/)
      expect(Rails.logger).to have_received(:info).with(/Request email body:/)
    end

    it 'uses default email when reply_email is not set' do
      course_settings.update(reply_email: nil)
      request.send_email_response

      expect(Rails.logger).to have_received(:info).with('Sending email from: flextensions@berkeley.edu')
    end

    it 'does not send email when emails are disabled' do
      course_settings.update(enable_emails: false)
      request.send_email_response

      expect(Rails.logger).not_to have_received(:info)
    end
  end
end
