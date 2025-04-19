require 'rails_helper'

RSpec.describe RequestsController, type: :controller do
  let(:user) { User.create!(email: 'student@example.com', canvas_uid: '123', name: 'Student') }
  let(:instructor) { User.create!(email: 'instructor@example.com', canvas_uid: '566', name: 'Instructor') }
  let(:course) { Course.create!(course_name: 'Test Course', canvas_id: '456', course_code: 'TST101') }
  let(:teacher_course) { Course.create!(course_name: 'Instructor Course', canvas_id: '999', course_code: 'INST101') }
  let(:assignment) { Assignment.create!(name: 'A1', course_to_lms_id: course_to_lms.id, external_assignment_id: 'x1', enabled: true) }
  let(:request) { Request.create!(user:, course:, assignment:, reason: 'Need more time', requested_due_date: Date.tomorrow) }
  let(:course_to_lms) { CourseToLms.create!(course:, lms_id: 1) }

  before do
    session[:user_id] = user.canvas_uid
    FormSetting.create!(
      course: course,
      documentation_disp: 'hidden',
      custom_q1_disp: 'hidden',
      custom_q2_disp: 'hidden'
    )
    Lms.find_or_create_by(id: 1, lms_name: 'Canvas', use_auth_token: true)
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
    let(:assignment) { Assignment.create!(name: 'Assignment 1', external_assignment_id: 'a1', course_to_lms_id: CourseToLms.create!(course: course, lms_id: 1).id, enabled: true) }
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
      expect(assigns(:assignments)).to eq([assignment])
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

  describe 'DELETE #destroy' do
    it 'deletes the request' do
      delete :destroy, params: { course_id: course.id, id: request.id }
      expect(response).to redirect_to(course_path(course))
      expect(flash[:notice]).to match(/deleted/)
    end
  end

  describe 'GET #history' do
    before do
      session[:user_id] = instructor.canvas_uid
      UserToCourse.create!(user: instructor, course: course, role: 'teacher')
      FormSetting.create!(course: course, documentation_disp: 'hidden', custom_q1_disp: 'hidden', custom_q2_disp: 'hidden')
      request.update!(status: 'approved')
    end

    it 'renders history for instructors' do
      get :history, params: { course_id: course.id }
      expect(response).to render_template('requests/instructor_history')
    end

    it 'redirects students from history page' do
      session[:user_id] = user.canvas_uid
      get :history, params: { course_id: course.id }
      expect(response).to redirect_to(course_path(course.id))
      expect(flash[:alert]).to eq('You do not have access to this page.')
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
end
