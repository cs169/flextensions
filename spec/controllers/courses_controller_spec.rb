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
        stub_request(:get, "#{ENV.fetch('CANVAS_URL', nil)}/api/v1/courses/456/users?enrollment_type=#{role}")
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

  describe 'GET #new' do
    before do
      # Create a fake LMS credential with a token
      user.lms_credentials.create!(lms_name: 'canvas', token: 'fake_token', expire_time: 1.hour.from_now)

      allow(Course).to receive(:fetch_courses).and_return([
                                                            {
                                                              'id' => '101',
                                                              'name' => 'Test Course 101',
                                                              'course_code' => 'TC101',
                                                              'enrollments' => [{ 'type' => 'teacher' }]
                                                            },
                                                            {
                                                              'id' => '102',
                                                              'name' => 'Test Course 102',
                                                              'course_code' => 'TC102',
                                                              'enrollments' => [{ 'type' => 'student' }]
                                                            }
                                                          ])
    end

    it 'fetches courses and categorizes them into teacher and student courses' do
      get :new

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)

      # You can check that @courses_teacher and @courses_student are set
      expect(assigns(:courses_teacher)).not_to be_empty
      expect(assigns(:courses_student)).not_to be_empty

      # Teacher course should be categorized correctly
      teacher_course = assigns(:courses_teacher).first
      expect(teacher_course['enrollments'].first['type']).to eq('teacher')

      # Student course should be categorized correctly
      student_course = assigns(:courses_student).first
      expect(student_course['enrollments'].first['type']).to eq('student')
    end

    it 'sets a flash alert if no courses are found' do
      allow(Course).to receive(:fetch_courses).and_return([])

      get :new

      expect(flash[:alert]).to eq('No courses found.')
    end
  end

  describe 'GET #enrollments' do
    before do
      # Create LMS credentials so user has a token
      user.lms_credentials.create!(lms_name: 'canvas', token: 'fake_token', expire_time: 1.hour.from_now)

      # Add user as a teacher so they are allowed to view enrollments
      UserToCourse.create!(user: user, course: course, role: 'teacher')

      CourseToLms.create!(course: course, lms_id: 1)
    end

    context 'when user is an instructor' do
      it 'renders the enrollments view successfully' do
        get :enrollments, params: { id: course.id }

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:enrollments)
        expect(assigns(:enrollments)).not_to be_nil

        # Check that the enrollments include the user
        enrollment_user_ids = assigns(:enrollments).map(&:user_id)
        expect(enrollment_user_ids).to include(user.id)
      end
    end
  end
end
