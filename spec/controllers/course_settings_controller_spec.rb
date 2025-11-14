require 'rails_helper'

RSpec.describe CourseSettingsController, type: :controller do
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

    describe 'POST #update' do
      it 'creates new course settings when none exist' do
        expect(CourseSettings.where(course_id: course.id).count).to eq(0)

        post :update, params: {
          course_id: course.id,
          course_settings: {
            enable_extensions: 'true',
            auto_approve_days: '3',
            auto_approve_extended_request_days: '5',
            enable_emails: 'true'
          },
          tab: 'general'
        }

        # Now verify a new settings record was created
        expect(CourseSettings.where(course_id: course.id).count).to eq(1)
        expect(response).to redirect_to(course_settings_path(course.id, tab: 'general'))
        expect(flash[:notice]).to eq('Course settings updated successfully.')
        settings = CourseSettings.find_by(course_id: course.id)
        expect(settings.enable_extensions).to be true
        expect(settings.auto_approve_days).to eq(3)
      end

      it 'updates existing course settings' do
        # Create existing settings
        course_settings = CourseSettings.create!(
          course: course,
          enable_extensions: false,
          auto_approve_days: 1,
          auto_approve_extended_request_days: 2,
          max_auto_approve: 5,
          enable_emails: false
        )

        expect(CourseSettings.where(course_id: course.id).count).to eq(1)

        post :update, params: {
          course_id: course.id,
          course_settings: {
            enable_extensions: 'true',
            auto_approve_days: '3'
          },
          tab: 'general'
        }

        expect(CourseSettings.where(course_id: course.id).count).to eq(1) # Still only 1 record
        expect(response).to redirect_to(course_settings_path(course.id, tab: 'general'))
        expect(flash[:notice]).to eq('Course settings updated successfully.')

        # Force reload to get updated values
        course_settings.reload
        expect(course_settings.enable_extensions).to be true
        expect(course_settings.auto_approve_days).to eq(3)
      end

      it 'handles update failures gracefully' do
        CourseSettings.create!(
          course: course,
          enable_extensions: false,
          auto_approve_days: 1
        )

        expect(CourseSettings.where(course_id: course.id).count).to eq(1)
        allow_any_instance_of(CourseSettings).to receive(:update).and_return(false)

        post :update, params: {
          course_id: course.id,
          course_settings: { enable_extensions: 'true' },
          tab: 'general'
        }

        expect(response).to redirect_to(course_settings_path(course.id, tab: 'general'))
        expect(flash[:alert]).to include('Failed to update course settings:')
      end

      it 'resets email templates and redirects' do
        CourseSettings.create!(
          course: course,
          enable_extensions: true,
          email_subject: 'Custom Subject',
          email_template: 'Custom Template'
        )

        post :update, params: {
          course_id: course.id,
          reset_email_template: true,
          tab: 'email'
        }

        expect(response).to redirect_to(course_settings_path(course.id, tab: 'email'))
        expect(flash[:notice]).to eq('Email templates reset to defaults.')
        # We won't test the exact content since that requires knowledge of the constants
      end
    end
  end

  describe 'pending requests count' do
    let(:assignment) do
      # Create necessary related objects for Request
      lms = Lms.first
      course_to_lms = CourseToLms.create!(course: course, lms: lms, external_course_id: '123')
      Assignment.create!(
        name: 'Test Assignment',
        course_to_lms: course_to_lms,
        due_date: 3.days.from_now,
        external_assignment_id: 'abc123',
        enabled: true
      )
    end

    before do
      session[:user_id] = instructor.canvas_uid
      UserToCourse.create!(user: instructor, course: course, role: 'instructor')
      allow_any_instance_of(Course).to receive(:user_role).with(instructor).and_return('instructor')

      # Create settings to enable extensions
      CourseSettings.create!(
        course: course,
        enable_extensions: true
      )

      # Clear instance variables before each test
      controller.instance_variable_set(:@pending_requests_count, nil)
    end

    it 'sets the correct pending requests count' do
      # Create a pending request with all required fields
      Request.create!(
        course: course,
        assignment: assignment,
        status: 'pending',
        user: student,
        reason: 'Need more time',
        requested_due_date: 5.days.from_now
      )

      # Stub the count query to ensure it returns 1
      requests = instance_double(ActiveRecord::Relation, count: 1)
      allow(Request).to receive(:where).with(course_id: course.id, status: 'pending').and_return(requests)

      post :update, params: {
        course_id: course.id,
        course_settings: { enable_extensions: 'true' },
        tab: 'general'
      }

      expect(assigns(:pending_requests_count)).to eq(1)
    end

    it 'handles when there are no pending requests' do
      # Stub the count query to ensure it returns 0
      requests = instance_double(ActiveRecord::Relation, count: 0)
      allow(Request).to receive(:where).with(course_id: course.id, status: 'pending').and_return(requests)

      post :update, params: {
        course_id: course.id,
        course_settings: { enable_extensions: 'true' },
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
      allow_any_instance_of(Course).to receive(:user_role).with(student).and_return('student')

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
          enable_extensions: 'true',
          auto_approve_days: '99'
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
        course_settings: { enable_extensions: 'true' },
        tab: 'general'
      }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('You must be logged in to access that page.')
    end

    it 'redirects to courses path when course is not found' do
      session[:user_id] = instructor.canvas_uid
      UserToCourse.create!(user: instructor, course: course, role: 'instructor')

      post :update, params: {
        course_id: 999,
        course_settings: { enable_extensions: 'true' },
        tab: 'general'
      }

      expect(response).to redirect_to(courses_path)
      expect(flash[:alert]).to eq('Course not found.')
    end
  end
end
