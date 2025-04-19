require 'rails_helper'

RSpec.describe CourseSettingsController, type: :controller do
  let(:canvas_uid) { '123' }
  let(:user) { User.create!(canvas_uid: canvas_uid, name: 'Test User', email: 'test@example.com') }
  let(:course) { Course.create!(course_name: 'Test Course', canvas_id: '123') }

  before do
    session[:user_id] = canvas_uid
    Lms.create!(lms_name: 'Canvas', use_auth_token: true)
    user.lms_credentials.create!(
      lms_name: 'canvas',
      token: 'fake_token',
      refresh_token: 'fake_refresh_token',
      expire_time: 1.hour.from_now
    )
    allow_any_instance_of(Course).to receive(:user_role).and_return('instructor')
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
        expect(course.course_settings.auto_approve_days).to eq(3)
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
        expect(course.course_settings.auto_approve_days).to eq(3)
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

      it 'resets email templates to defaults when requested' do
        course_settings.update(
          email_subject: 'Custom Subject',
          email_template: 'Custom Template'
        )

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

  describe 'authentication and authorization' do
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
      allow(Course).to receive(:find_by).and_return(nil)

      post :update, params: {
        course_id: 999,
        course_settings: { enable_extensions: true },
        tab: 'general'
      }

      expect(response).to redirect_to(courses_path)
      expect(flash[:alert]).to eq('Course not found.')
    end
  end

  describe 'pending requests count' do
    let!(:lms) { Lms.create!(lms_name: 'Canvas', use_auth_token: true) }
    let!(:course_to_lms) { CourseToLms.create!(course: course, lms: lms, external_course_id: '123') }
    let!(:assignment) do
      Assignment.create!(
        name: 'Test Assignment',
        course_to_lms: course_to_lms,
        external_assignment_id: 'abc123',
        enabled: true
      )
    end

    it 'sets the pending requests count correctly' do
      pending_request = Request.create!(
        course: course,
        assignment: assignment,
        user: user,
        status: 'pending',
        reason: 'Test reason',
        requested_due_date: 5.days.from_now
      )

      post :update, params: {
        course_id: course.id,
        course_settings: { enable_extensions: true },
        tab: 'general'
      }

      expect(assigns(:pending_requests_count)).to eq(1)
      expect(assigns(:pending_requests_count)).to eq(Request.where(id: pending_request.id, status: 'pending').count)
    end
  end
end
