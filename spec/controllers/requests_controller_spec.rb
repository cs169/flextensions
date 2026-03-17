require 'rails_helper'

RSpec.describe RequestsController, type: :controller do
  let(:user) { User.create!(email: 'student@example.com', canvas_uid: '123', name: 'Student') }
  let(:instructor) { User.create!(email: 'instructor@example.com', canvas_uid: '566', name: 'Instructor') }
  let(:course) { create(:course, :with_staff, course_name: 'Test Course', canvas_id: '456', course_code: 'TST101') }
  let(:teacher_course) { Course.create!(course_name: 'Instructor Course', canvas_id: '999', course_code: 'INST101') }
  let(:assignment) do
    Assignment.create!(
      name: 'A1',
      course_to_lms_id: course_to_lms.id,
      due_date: 2.days.from_now,
      external_assignment_id: 'x1',
      enabled: true
    )
  end
  let(:request) { Request.create!(user:, course:, assignment:, reason: 'Need more time', requested_due_date: 4.days.from_now) }
  let(:course_to_lms) { CourseToLms.create!(course:, lms_id: 1) }

  before do
    session[:user_id] = user.canvas_uid
    FormSetting.create!(
      course: course,
      documentation_disp: 'hidden',
      custom_q1_disp: 'hidden',
      custom_q2_disp: 'hidden'
    )
    UserToCourse.create!(user: user, course: course, role: 'student')
    CourseToLms.create!(course:, lms_id: 1)

    user.lms_credentials.create!(
      lms_name: 'canvas',
      token: 'fake_token',
      refresh_token: 'fake_refresh_token',
      expire_time: 1.hour.from_now
    )
  end

  describe 'GET #index' do
    it 'renders student request index' do
      get :index, params: { course_id: course.id }
      expect(response).to render_template('requests/student_index')
    end

    it 'renders instructor request index' do
      session[:user_id] = instructor.canvas_uid
      UserToCourse.create!(user: instructor, course: teacher_course, role: 'teacher') # or use 'ta'
      FormSetting.create!(course: teacher_course, documentation_disp: 'hidden', custom_q1_disp: 'hidden', custom_q2_disp: 'hidden')
      get :index, params: { course_id: teacher_course.id }

      expect(response).to have_http_status(:ok)
      expect(response).to render_template('requests/instructor_index')
    end

    it 'assigns @search_query from params[:search]' do
      session[:user_id] = instructor.canvas_uid
      UserToCourse.create!(user: instructor, course: teacher_course, role: 'teacher')
      FormSetting.create!(course: teacher_course, documentation_disp: 'hidden', custom_q1_disp: 'hidden', custom_q2_disp: 'hidden')

      get :index, params: { course_id: teacher_course.id, search: '12345', show_all: 'true' }

      expect(assigns(:search_query)).to eq('12345')
    end

    it 'assigns @search_query as nil when no search param is provided' do
      session[:user_id] = instructor.canvas_uid
      UserToCourse.create!(user: instructor, course: teacher_course, role: 'teacher')
      FormSetting.create!(course: teacher_course, documentation_disp: 'hidden', custom_q1_disp: 'hidden', custom_q2_disp: 'hidden')

      get :index, params: { course_id: teacher_course.id }

      expect(assigns(:search_query)).to be_nil
    end
  end

  describe 'GET #show' do
    it 'renders the request details' do
      get :show, params: { course_id: course.id, id: request.id }
      expect(response).to render_template('requests/student_show')
    end
  end

  describe 'GET #new' do
    it 'renders new request form' do
      get :new, params: { course_id: course.id }
      expect(response).to render_template('requests/new')
    end
  end

  describe 'POST #create' do
    it 'creates a request and redirects' do
      post :create, params: {
        course_id: course.id,
        request: {
          assignment_id: assignment.id,
          reason: 'Sick',
          requested_due_date: Date.tomorrow.to_s,
          due_time: '10:00'
        }
      }
      expect(response).to redirect_to(course_request_path(course, Request.last))
      expect(flash[:notice]).to match(/submitted/)
    end

    context 'with auto-approval enabled' do
      let(:canvas_facade_instance) { CanvasFacade.new('fake_token') }
      let(:override_double) { instance_double(Lmss::Canvas::Override, id: 'override-1') }

      before do
        course.course_settings.update!(
          enable_extensions: true,
          auto_approve_days: 5,
          max_auto_approve: 3
        )

        assignment.update(due_date: 1.day.from_now)

        allow(SystemUserService).to receive(:ensure_auto_approval_user_exists).and_return(instructor)
        allow(CanvasFacade).to receive(:from_user).and_return(canvas_facade_instance)
        allow(canvas_facade_instance).to receive(:provision_extension).and_return(override_double)
      end

      it 'auto-approves eligible requests' do
        post :create, params: {
          course_id: course.id,
          request: {
            assignment_id: assignment.id,
            reason: 'Sick',
            requested_due_date: 3.days.from_now.to_s,
            due_time: '10:00'
          }
        }

        created_request = Request.last
        expect(created_request.status).to eq('approved')
        expect(created_request.auto_approved).to be true
        expect(response).to redirect_to(course_request_path(course, created_request))
        expect(flash[:notice]).to match(/approved/)
      end

      it 'submits without auto-approval when extension is too long' do
        post :create, params: {
          course_id: course.id,
          request: {
            assignment_id: assignment.id,
            reason: 'Sick',
            requested_due_date: 10.days.from_now.to_s,
            due_time: '10:00'
          }
        }

        created_request = Request.last
        expect(created_request.status).not_to eq('approved')
        expect(created_request.auto_approved).to be_falsey
        expect(response).to redirect_to(course_request_path(course, created_request))
        expect(flash[:notice]).to match(/submitted/)
      end

      it 'redirects when auto-approval is disabled' do
        CourseSettings.update(course.course_settings.id, enable_extensions: false)
        course.reload

        post :create, params: {
          course_id: course.id,
          request: {
            assignment_id: assignment.id,
            reason: 'Sick',
            requested_due_date: 3.days.from_now.to_s,
            due_time: '10:00'
          }
        }

        # Should redirect with the appropriate message
        expect(response).to redirect_to(courses_path)
        expect(flash[:alert]).to eq('Extensions are not enabled for this course.')
        expect(Request.last).to be_nil # No request should be created
      end

      it 'submits without auto-approval when max approvals reached' do
        CourseSettings.update(course.course_settings.id, max_auto_approve: 1)

        # Create a pre-existing approved request
        Request.create!(
          user: user,
          course: course,
          assignment: assignment,
          reason: 'Previous request',
          requested_due_date: 3.days.from_now,
          status: 'approved',
          auto_approved: true
        )

        allow_any_instance_of(Request).to receive(:process_created_request).and_call_original

        post :create, params: {
          course_id: course.id,
          request: {
            assignment_id: assignment.id,
            reason: 'Sick',
            requested_due_date: 3.days.from_now.to_s,
            due_time: '10:00'
          }
        }

        created_request = Request.order(:created_at).last
        expect(response).to redirect_to(course_request_path(course, created_request))
        expect(flash[:notice]).to match(/submitted/)
      end
    end

    it 're-renders new if the request is invalid' do
      post :create, params: {
        course_id: course.id,
        request: {
          assignment_id: '',   # Missing assignment ID
          reason: '',          # Missing reason
          requested_due_date: ''
        }
      }

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
      expect(flash[:alert]).to eq('There was a problem submitting your request.')
    end
  end

  describe 'GET #edit' do
    let(:assignment) do
      Assignment.create!(
        name: 'Assignment 1',
        external_assignment_id: 'a1',
        due_date: 1.day.from_now,
        course_to_lms_id: CourseToLms.create!(course: course, lms_id: 1).id, enabled: true
      )
    end
    let(:request_record) do
      Request.create!(
        assignment: assignment,
        course: course,
        user: user,
        reason: 'Need more time',
        requested_due_date: 3.days.from_now
      )
    end

    it 'assigns the request and selected assignment' do
      get :edit, params: { course_id: course.id, id: request_record.id }

      expect(response).to have_http_status(:ok)
      expect(assigns(:request)).to eq(request_record)
      expect(assigns(:selected_assignment)).to eq(assignment)
      expect(assigns(:assignments)).to eq([ assignment ])
      expect(response).to render_template(:edit)
    end

    it 'redirects if request is not found' do
      get :edit, params: { course_id: course.id, id: '9999' }

      expect(response).to redirect_to(course_path(course))
      expect(flash[:alert]).to eq('Request not found.')
    end
  end

  describe 'PATCH #update' do
    it 'updates request and redirects' do
      patch :update, params: {
        course_id: course.id,
        id: request.id,
        request: {
          reason: 'Updated reason',
          requested_due_date: Date.tomorrow.to_s,
          due_time: '12:00'
        }
      }
      expect(response).to redirect_to(course_request_path(course, request))
      expect(flash[:notice]).to match(/updated/)
    end
  end

  describe 'POST #cancel' do
    before do
      session[:user_id] = user.canvas_uid
      UserToCourse.create!(user: user, course: course, role: 'student')
    end

    it 'cancels the request and updates its status to denied' do
      post :cancel, params: { course_id: course.id, id: request.id }

      expect(response).to redirect_to(course_requests_path(course))
      expect(flash[:notice]).to match(/Request canceled successfully./i)
      expect(request.reload.status).to eq('denied')
    end

    it 'redirects if the request is not found' do
      post :cancel, params: { course_id: course.id, id: '9999' }

      expect(response).to redirect_to(course_path(course))
      expect(flash[:alert]).to eq('Request not found.')
    end

    it 'does not cancel a request if it fails to update' do
      allow_any_instance_of(Request).to receive(:reject).and_return(false)

      post :cancel, params: { course_id: course.id, id: request.id }

      expect(response).to redirect_to(course_requests_path(course))
      expect(flash[:alert]).to match('Failed to cancel the request.')
      expect(request.reload.status).not_to eq('denied')
    end
  end

  describe 'POST #approve' do
    before do
      session[:user_id] = instructor.canvas_uid
      UserToCourse.create!(user: instructor, course: course, role: 'teacher')
      instructor.lms_credentials.create!(
        lms_name: 'canvas',
        token: 'instructor_token',
        refresh_token: 'instructor_refresh',
        expire_time: 1.hour.from_now
      )
      FormSetting.create!(
        course: course,
        documentation_disp: 'hidden',
        custom_q1_disp: 'hidden',
        custom_q2_disp: 'hidden'
      )

      # stub out Canvas bits so that your Request#approve never blows up
      stub_request(:get,  "#{ENV.fetch('CANVAS_URL', nil)}/api/v1/courses/456/assignments/x1/overrides")
        .with(headers: { 'Authorization' => 'Bearer instructor_token' })
        .to_return(status: 200, body: '[]', headers: {})

      stub_request(:post, "#{ENV.fetch('CANVAS_URL', nil)}/api/v1/courses/456/assignments/x1/overrides")
        .with(headers: { 'Authorization' => 'Bearer instructor_token' })
        .to_return(
          status: 200,
          body: { id: 'override-1' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'approves a pending request' do
      allow(request).to receive(:approve).and_return(true)

      post :approve, params: { course_id: course.id, id: request.id }

      expect(response).to redirect_to(course_requests_path(course))
      expect(flash[:notice]).to match(/approved/i)
    end

    # it 'shows error if approval fails' do
    #   # stub the *same* request to return false here
    #   allow(request).to receive(:approve).and_return(false)

    #   post :approve, params: { course_id: course.id, id: request.id }

    #   expect(response).to redirect_to(course_requests_path(course))
    #   expect(flash[:alert]).to match(/failed/i)
    # end
  end

  describe 'POST #reject' do
    before do
      session[:user_id] = instructor.canvas_uid
      UserToCourse.create!(user: instructor, course: course, role: 'teacher')
      FormSetting.create!(course: course, documentation_disp: 'hidden', custom_q1_disp: 'hidden', custom_q2_disp: 'hidden')
    end

    it 'rejects a pending request' do
      post :reject, params: { course_id: course.id, id: request.id }
      expect(response).to redirect_to(course_requests_path(course))
      expect(flash[:notice]).to match(/denied/i)
    end

    it 'shows error if rejection fails' do
      allow_any_instance_of(Request).to receive(:reject).and_return(false)
      post :reject, params: { course_id: course.id, id: request.id }
      expect(response).to redirect_to(course_requests_path(course))
      expect(flash[:alert]).to match(/failed/i)
    end
  end

  describe 'Pending requests handling' do
    let(:course) { Course.create!(course_name: 'Test Course', canvas_id: '1234', course_code: 'TST123') }
    let(:user) { User.create!(name: 'Test User', canvas_uid: '5678', email: 'test@example.com') }
    let(:assignment) { Assignment.create!(name: 'Assignment 1', external_assignment_id: 'a1', course_to_lms_id: CourseToLms.create!(course: course, lms_id: 1).id, enabled: true, due_date: 2.days.from_now) }

    before do
      session[:user_id] = user.canvas_uid
      UserToCourse.create!(user: user, course: course, role: 'student')

      # Create course settings for auto-approval
      CourseSettings.create!(
        course: course,
        enable_extensions: true,
        auto_approve_days: 3,
        max_auto_approve: 5
      )

      # Set up form settings
      FormSetting.create!(
        course: course,
        documentation_disp: 'hidden',
        custom_q1_disp: 'hidden',
        custom_q2_disp: 'hidden'
      )

      # Create LMS
      Lms.find_or_create_by(id: 1, lms_name: 'Canvas', use_auth_token: true)
    end

    it 'filters out assignments with pending requests from the form' do
      # Create a pending request for the assignment
      Request.create!(
        user: user,
        course: course,
        assignment: assignment,
        reason: 'Need more time',
        requested_due_date: assignment.due_date + 1.day,
        status: 'pending'
      )

      # Get the new request form
      get :new, params: { course_id: course.id }

      # The assignment with a pending request should not be in the list
      expect(assigns(:assignments)).not_to include(assignment)
    end

    it 'redirects to the existing request if user tries to create a new one for an assignment with pending request' do
      # Create a pending request for the assignment
      pending_request = Request.create!(
        user: user,
        course: course,
        assignment: assignment,
        reason: 'Need more time',
        requested_due_date: assignment.due_date + 1.day,
        status: 'pending'
      )

      # Try to access the new request form with this assignment
      get :new, params: { course_id: course.id, assignment_id: assignment.id }

      # Should redirect to the existing request
      expect(response).to redirect_to(course_request_path(course, pending_request))
    end

    it 'prevents creating a new request for an assignment with a pending request' do
      # Create a pending request for the assignment
      Request.create!(
        user: user,
        course: course,
        assignment: assignment,
        reason: 'Need more time',
        requested_due_date: assignment.due_date + 1.day,
        status: 'pending'
      )

      # Try to create a new request for the same assignment
      post :create, params: {
        course_id: course.id,
        request: {
          assignment_id: assignment.id,
          reason: 'Another reason',
          requested_due_date: (assignment.due_date + 2.days).to_s,
          due_time: '12:00'
        }
      }

      # Should redirect and not create a new request
      expect(response).to redirect_to(course_requests_path(course))
      expect(flash[:alert]).to match(/already have a pending request/)
    end
  end

  describe 'Auto-approval for edited requests' do
    let(:course) { Course.create!(course_name: 'Test Course', canvas_id: '1234', course_code: 'TST123') }
    let(:user) { User.create!(name: 'Test User', canvas_uid: '5678', email: 'test@example.com') }
    let(:assignment) { Assignment.create!(name: 'Assignment 1', external_assignment_id: 'a1', course_to_lms_id: CourseToLms.create!(course: course, lms_id: 1).id, enabled: true, due_date: 2.days.from_now) }
    let(:request_record) do
      Request.create!(
        user: user,
        course: course,
        assignment: assignment,
        reason: 'Need more time',
        requested_due_date: assignment.due_date + 1.day,
        status: 'pending'
      )
    end

    before do
      session[:user_id] = user.canvas_uid
      UserToCourse.create!(user: user, course: course, role: 'student')

      # Create course settings for auto-approval
      CourseSettings.create!(
        course: course,
        enable_extensions: true,
        auto_approve_days: 3,
        max_auto_approve: 5
      )

      # Set up form settings
      FormSetting.create!(
        course: course,
        documentation_disp: 'hidden',
        custom_q1_disp: 'hidden',
        custom_q2_disp: 'hidden'
      )

      # Create LMS
      Lms.find_or_create_by(id: 1, lms_name: 'Canvas', use_auth_token: true)

      # Create credentials for user
      user.lms_credentials.create!(
        lms_name: 'canvas',
        token: 'fake_token',
        refresh_token: 'fake_refresh_token',
        expire_time: 1.hour.from_now
      )
    end

    it 'attempts auto-approval when editing a pending request' do
      # Mock the auto-approval method
      expect_any_instance_of(Request).to receive(:try_auto_approval).and_return(true)

      # Update the request
      patch :update, params: {
        course_id: course.id,
        id: request_record.id,
        request: {
          reason: 'Updated reason',
          requested_due_date: (assignment.due_date + 2.days).to_s,
          due_time: '12:00'
        }
      }

      # Should redirect with appropriate message
      expect(response).to redirect_to(course_request_path(course, request_record))
      expect(flash[:notice]).to match(/updated and has been approved/)
    end

    it 'does not auto-approve if conditions are not met' do
      # Mock the auto-approval method to return false
      expect_any_instance_of(Request).to receive(:try_auto_approval).and_return(false)

      # Update the request
      patch :update, params: {
        course_id: course.id,
        id: request_record.id,
        request: {
          reason: 'Updated reason',
          requested_due_date: (assignment.due_date + 4.days).to_s, # Beyond auto-approval threshold
          due_time: '12:00'
        }
      }

      # Should redirect with standard update message
      expect(response).to redirect_to(course_request_path(course, request_record))
      expect(flash[:notice]).to match(/successfully updated/)
      expect(flash[:notice]).not_to match(/has been approved/)
    end
  end
end
