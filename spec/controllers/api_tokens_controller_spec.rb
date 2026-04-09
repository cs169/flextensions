require 'rails_helper'

RSpec.describe ApiTokensController, type: :controller do
  let(:instructor) { User.create!(canvas_uid: '123', name: 'Instructor', email: 'instructor@example.com') }
  let(:student) { User.create!(canvas_uid: '456', name: 'Student', email: 'student@example.com') }
  let(:course) { Course.create!(course_name: 'Test Course', canvas_id: '123') }

  before do
    instructor.lms_credentials.create!(
      lms_name: 'canvas',
      token: 'fake_token',
      refresh_token: 'fake_refresh_token',
      expire_time: 1.hour.from_now
    )
  end

  describe 'instructor access' do
    before do
      session[:user_id] = instructor.canvas_uid
      UserToCourse.create!(user: instructor, course: course, role: 'instructor')
      allow_any_instance_of(Course).to receive(:user_role).with(instructor).and_return('instructor')
    end

    describe 'GET #index' do
      it 'renders the index template' do
        get :index, params: { course_id: course.id }
        expect(response).to render_template(:index)
      end

      it 'assigns api_tokens for the course' do
        token = ApiToken.create!(
          course: course, user: instructor, created_by: instructor,
          expires_at: 30.days.from_now
        )

        get :index, params: { course_id: course.id }
        expect(assigns(:api_tokens)).to include(token)
      end

      it 'does not include tokens from other courses' do
        other_course = Course.create!(course_name: 'Other Course', canvas_id: '999')
        other_token = ApiToken.create!(
          course: other_course, user: instructor, created_by: instructor,
          expires_at: 30.days.from_now
        )

        get :index, params: { course_id: course.id }
        expect(assigns(:api_tokens)).not_to include(other_token)
      end

      it 'sets @side_nav to api_tokens' do
        get :index, params: { course_id: course.id }
        expect(assigns(:side_nav)).to eq('api_tokens')
      end

      it 'sets @pending_requests_count' do
        get :index, params: { course_id: course.id }
        expect(assigns(:pending_requests_count)).to eq(0)
      end
    end

    describe 'DELETE #destroy' do
      it 'revokes the token and redirects with notice' do
        token = ApiToken.create!(
          course: course, user: instructor, created_by: instructor,
          expires_at: 30.days.from_now
        )

        delete :destroy, params: { course_id: course.id, id: token.id }

        expect(token.reload.revoked_at).to be_present
        expect(response).to redirect_to(course_api_tokens_path(course))
        expect(flash[:notice]).to eq('API token revoked successfully.')
      end

      it 'returns alert when token not found' do
        delete :destroy, params: { course_id: course.id, id: 999 }

        expect(response).to redirect_to(course_api_tokens_path(course))
        expect(flash[:alert]).to eq('API token not found.')
      end

      it 'does not allow revoking tokens from another course' do
        other_course = Course.create!(course_name: 'Other Course', canvas_id: '999')
        other_token = ApiToken.create!(
          course: other_course, user: instructor, created_by: instructor,
          expires_at: 30.days.from_now
        )

        delete :destroy, params: { course_id: course.id, id: other_token.id }

        expect(other_token.reload.revoked_at).to be_nil
        expect(flash[:alert]).to eq('API token not found.')
      end
    end
  end

  describe 'student access' do
    before do
      session[:user_id] = student.canvas_uid
      student.lms_credentials.create!(
        lms_name: 'canvas',
        token: 'student_token',
        refresh_token: 'student_refresh_token',
        expire_time: 1.hour.from_now
      )
      UserToCourse.create!(user: student, course: course, role: 'student')
      allow_any_instance_of(Course).to receive(:user_role).with(student).and_return('student')
    end

    it 'denies access to index' do
      get :index, params: { course_id: course.id }

      expect(response).to redirect_to(courses_path)
      expect(flash[:alert]).to eq('You do not have access to this page.')
    end

    it 'denies access to destroy' do
      token = ApiToken.create!(
        course: course, user: instructor, created_by: instructor,
        expires_at: 30.days.from_now
      )

      delete :destroy, params: { course_id: course.id, id: token.id }

      expect(response).to redirect_to(courses_path)
      expect(token.reload.revoked_at).to be_nil
    end
  end

  describe 'authentication' do
    it 'redirects to root path when user is not authenticated' do
      session[:user_id] = 'non_existent_id'

      get :index, params: { course_id: course.id }

      expect(response).to redirect_to(root_path)
    end

    it 'redirects to courses path when course is not found' do
      session[:user_id] = instructor.canvas_uid

      get :index, params: { course_id: 999 }

      expect(response).to redirect_to(courses_path)
      expect(flash[:alert]).to eq('Course not found.')
    end
  end
end
