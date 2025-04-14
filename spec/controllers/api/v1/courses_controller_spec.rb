require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  let(:user) { User.create!(email: 'student@example.com', canvas_uid: '123', name: 'Student') }
  let(:course) { Course.create!(course_name: 'Test Course', canvas_id: '456', course_code: 'TST101') }
  let(:student_course) { Course.create!(course_name: 'Student Course', canvas_id: '789', course_code: 'STU101') }

  before do
    session[:user_id] = user.canvas_uid
    UserToCourse.create!(user: user, course: course, role: 'student')
    Lms.find_or_create_by(id: 1, lms_name: 'Canvas', use_auth_token: true)
    user.lms_credentials.create!(
      lms_name: 'canvas',
      token: 'fake_token',
      refresh_token: 'fake_refresh_token',
      expire_time: 1.hour.from_now
    )
  end

  describe 'GET #index' do
    it 'responds successfully' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    context 'when course exists' do
      before do
        CourseToLms.create!(course: course, lms_id: 1)
        Assignment.create!(name: 'Assignment 1', course_to_lms_id: course.course_to_lmss.first.id, external_assignment_id: 'xyz', enabled: true)
      end

      it 'renders the correct student view' do
        get :show, params: { id: course.id }
        expect(response).to render_template('courses/student_view')
      end
    end

    context 'when course does not exist' do
      it 'redirects to courses_path with alert' do
        get :show, params: { id: '9999' }
        expect(response).to redirect_to(courses_path)
        expect(flash[:alert]).to eq('Course not found.')
      end
    end
  end

  describe 'GET #edit' do
    it 'redirects non-instructor users' do
      get :edit, params: { id: course.id }
      expect(response).to redirect_to(course_path(course))
      expect(flash[:alert]).to eq('You do not have access to this page.')
    end
  end

  describe 'POST #create' do
    # before do
    #   user.update(canvas_token: 'fake_token')
    # end

    it 'redirects to courses_path after importing courses' do
      allow(Course).to receive_messages(fetch_courses: [
                                          { 'id' => '456', 'name' => 'New Canvas Course', 'course_code' => 'C101', 'enrollments' => [{ 'type' => 'teacher' }] }
                                        ], create_or_update_from_canvas: true)

      post :create, params: { courses: ['456'] }

      expect(response).to redirect_to(courses_path)
      expect(flash[:notice]).to eq('Selected courses and their assignments have been imported successfully.')
    end
  end

  describe 'POST #sync_assignments' do
    it 'syncs assignments and returns OK' do
      # user.update(canvas_token: 'fake_token')
      CourseToLms.create!(course: course, lms_id: 1)
      allow(Course).to receive(:create_or_update_from_canvas)

      post :sync_assignments, params: { id: course.id }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq({ 'message' => 'Assignments synced successfully.' })
    end
  end

  describe 'POST #sync_enrollments' do
    before do
      roles = %w[teacher ta student]
      roles.each do |role|
        stub_request(:get, "https://ucberkeleysandbox.instructure.com//api/v1/courses/456/users?enrollment_type=#{role}")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization' => 'Bearer fake_token',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Faraday v2.12.2'
            }
          )
          .to_return(status: 200, body: '[]', headers: {})
      end
    end

    it 'syncs enrollments and returns OK' do
      # user.update(canvas_token: 'fake_token')
      allow(course).to receive(:sync_enrollments_from_canvas)

      post :sync_enrollments, params: { id: course.id }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq({ 'message' => 'Users synced successfully.' })
    end
  end

  describe 'POST #delete_all' do
    it 'deletes user courses and redirects' do
      delete :delete_all
      expect(response).to redirect_to(courses_path)
      expect(flash[:notice]).to eq('All your courses and associations have been deleted successfully.')
    end
  end
end
