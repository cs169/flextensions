require 'rails_helper'

RSpec.describe CourseSettingsController, type: :controller do
  let(:instructor) { User.create!(canvas_uid: '123', name: 'Instructor', email: 'instructor@example.com') }
  let(:student) { User.create!(canvas_uid: '456', name: 'Student', email: 'student@example.com') }
  let(:course) { Course.create!(course_name: 'Test Course', canvas_id: '123') }

  before do
    Lms.create!(lms_name: 'Canvas', use_auth_token: true)
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
    end

    describe 'GET #index' do
      it 'renders the index template' do
        get :index, params: { course_id: course.id }

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
      end

      it 'assigns the correct course' do
        get :index, params: { course_id: course.id }

        expect(assigns(:course)).to eq(course)
      end
    end

    describe 'POST #update' do
      context 'when course settings do not exist' do
        it 'creates new course settings' do
          expect do
            post :update, params: {
              course_id: course.id,
              course_settings: {
                enable_extensions: true,
                auto_approve_days: 3,
                auto_approve_dsp_days: 5,
                enable_emails: true
              },
              tab: 'general'
            }
          end.to change { course.reload.course_settings.present? }.from(false).to(true)

          expect(response).to redirect_to(course_settings_path(course, tab: 'general'))
          expect(flash[:notice]).to eq('Course settings updated successfully.')
          expect(course.reload.course_settings.enable_extensions).to be true
          expect(course.reload.course_settings.auto_approve_days).to eq(3)
        end
      end

      context 'when course settings already exist' do
        let!(:course_settings) do
          CourseSettings.create!(
            course: course,
            enable_extensions: false,
            auto_approve_days: 1,
            auto_approve_dsp_days: 2,
            max_auto_approve: 5,
            enable_emails: false
          )
        end

        it 'updates existing course settings' do
          expect do
            post :update, params: {
              course_id: course.id,
              course_settings: {
                enable_extensions: true,
                auto_approve_days: 3
              },
              tab: 'general'
            }
          end.not_to change(CourseSettings, :count)

          expect(response).to redirect_to(course_settings_path(course, tab: 'general'))
          expect(flash[:notice]).to eq('Course settings updated successfully.')
          expect(course.reload.course_settings.enable_extensions).to be true
          expect(course.reload.course_settings.auto_approve_days).to eq(3)
        end

        it 'handles update failures gracefully' do
          allow_any_instance_of(CourseSettings).to receive(:update).and_return(false)

          post :update, params: {
            course_id: course.id,
            course_settings: { enable_extensions: true },
            tab: 'general'
          }

          expect(response).to redirect_to(course_settings_path(course, tab: 'general'))
          expect(flash[:alert]).to eq('Failed to update course settings.')
        end
      end

      context 'resetting email templates' do
        let!(:course_settings) do
          CourseSettings.create!(
            course: course,
            enable_extensions: true,
            email_subject: 'Custom Subject',
            email_template: 'Custom Template'
          )
        end

        it 'resets email templates and redirects' do
          post :update, params: {
            course_id: course.id,
            reset_email_template: true,
            tab: 'email'
          }

          expect(response).to redirect_to(course_settings_path(course, tab: 'email'))
          expect(flash[:notice]).to eq('Email templates reset to defaults.')
          expect(course.reload.course_settings.email_subject).to eq(CourseSettingsController::DEFAULT_EMAIL_SUBJECT)
          expect(course.reload.course_settings.email_template).to eq(CourseSettingsController::DEFAULT_EMAIL_TEMPLATE)
        end
      end
    end
  end

  describe 'pending requests count' do
    before do
      session[:user_id] = instructor.canvas_uid
      UserToCourse.create!(user: instructor, course: course, role: 'teacher')
      allow_any_instance_of(Course).to receive(:user_role).and_return('instructor')

      # Create settings to enable extensions
      CourseSettings.create!(
        course: course,
        enable_extensions: true
      )
    end

    it 'sets the correct pending requests count' do
      # Create a pending request
      request = Request.create!(
        course: course,
        status: 'pending',
        user: student
      )

      post :update, params: {
        course_id: course.id,
        course_settings: { enable_extensions: true },
        tab: 'general'
      }

      expect(assigns(:pending_requests_count)).to eq(1)
    end

    it 'handles when there are no pending requests' do
      post :update, params: {
        course_id: course.id,
        course_settings: { enable_extensions: true },
        tab: 'general'
      }

      expect(assigns(:pending_requests_count)).to eq(0)
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
      allow_any_instance_of(Course).to receive(:user_role).and_return('student')

      # Create some course settings to attempt to modify
      CourseSettings.create!(
        course: course,
        enable_extensions: false,
        auto_approve_days: 1
      )
    end

    it 'denies access to update course settings' do
      post :update, params: {
        course_id: course.id,
        course_settings: {
          enable_extensions: true,
          auto_approve_days: 99
        },
        tab: 'general'
      }

      expect(response).to redirect_to(courses_path)
      expect(flash[:alert]).to eq('You do not have access to this page.')

      # Verify settings were not changed
      expect(course.reload.course_settings.enable_extensions).to be false
      expect(course.reload.course_settings.auto_approve_days).to eq(1)
    end

    it 'denies access to reset email templates' do
      post :update, params: {
        course_id: course.id,
        reset_email_template: true,
        tab: 'email'
      }

      expect(response).to redirect_to(courses_path)
      expect(flash[:alert]).to eq('You do not have access to this page.')
    end
  end

  describe 'authentication issues' do
    it 'redirects to root path when user is not authenticated' do
      session[:user_id] = 'non_existent_id'

      post :update, params: {
        course_id: course.id,
        course_settings: { enable_extensions: true },
        tab: 'general'
      }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('User not found in the database.')
    end

    it 'redirects to courses path when course is not found' do
      session[:user_id] = instructor.canvas_uid
      UserToCourse.create!(user: instructor, course: course, role: 'teacher')
      allow_any_instance_of(Course).to receive(:user_role).and_return('instructor')

      post :update, params: {
        course_id: 999,
        course_settings: { enable_extensions: true },
        tab: 'general'
      }

      expect(response).to redirect_to(courses_path)
      expect(flash[:alert]).to eq('Course not found.')
    end
  end
end
