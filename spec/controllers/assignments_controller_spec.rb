# spec/controllers/assignments_controller_spec.rb
require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do
  before do
    session[:user_id] = '123'
  end

  describe 'POST #toggle_enabled' do
    let!(:user) { User.create!(name: 'Test User', email: 'test@example.com') }
    let!(:course) { Course.create!(course_name: 'Test Course', canvas_id: '123') }
    let!(:lms) { Lms.create!(lms_name: 'Canvas', use_auth_token: true) }
    let!(:course_to_lms) { CourseToLms.create!(course: course, lms: lms, external_course_id: '123') }
    let!(:course_settings) { CourseSettings.create!(course: course, enable_extensions: true) }
    let!(:assignment) do
      Assignment.create!(
        name: 'Test Assignment',
        course_to_lms: course_to_lms,
        due_date: 3.days.from_now,
        external_assignment_id: 'abc123',
        enabled: false
      )
    end

    context 'when the user is an instructor' do
      before do
        allow(course).to receive(:user_role).with(user).and_return('instructor')
      end

      it 'updates the enabled status to true' do
        post :toggle_enabled, params: { id: assignment.id, enabled: true, role: 'instructor', user_id: user.id }

        expect(response).to have_http_status(:ok)
        expect(assignment.reload.enabled).to be true
      end

      it 'updates the enabled status to false' do
        assignment.update!(enabled: true)

        post :toggle_enabled, params: { id: assignment.id, enabled: false, role: 'instructor', user_id: user.id }

        expect(response).to have_http_status(:ok)
        expect(assignment.reload.enabled).to be false
      end
    end

    context 'when the user is not an instructor' do
      before do
        allow(course).to receive(:user_role).with(user).and_return('student')
      end

      it 'returns a forbidden status' do
        post :toggle_enabled, params: { id: assignment.id, enabled: true, role: 'student', user_id: user.id }

        expect(response).to have_http_status(:forbidden)
        expect(assignment.reload.enabled).to be false
      end
    end

    context 'when course-level extensions are disabled' do
      before do
        course_settings.update!(enable_extensions: false)
        allow(course).to receive(:user_role).with(user).and_return('instructor')
      end

      it 'still allows enabling the assignment and returns ok status' do
        post :toggle_enabled, params: { id: assignment.id, enabled: true, role: 'instructor', user_id: user.id }

        expect(response).to have_http_status(:ok)
        expect(assignment.reload.enabled).to be true
      end
    end

    context 'when there is no due_date on an Assignment' do
      before do
        assignment.update!(due_date: nil)
      end

      it 'returns a bad request status' do
        post :toggle_enabled, params: { id: assignment.id, enabled: true, role: 'instructor', user_id: user.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:alert]).to include('Due date must be present if assignment is enabled')
      end
    end

    context 'when user_id is not provided' do
      before do
        allow(course).to receive(:user_role).and_return('instructor')
      end

      it 'uses the session user and updates the assignment' do
        post :toggle_enabled, params: { id: assignment.id, enabled: true, role: 'instructor' }

        expect(response).to have_http_status(:ok)
        expect(assignment.reload.enabled).to be true
      end
    end
  end
end
