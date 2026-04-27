# spec/controllers/assignments_controller_spec.rb
require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do
  before do
    session[:user_id] = '123'
  end

  describe 'POST #toggle_enabled' do
    let!(:user) { User.create!(name: 'Test User', email: 'test@example.com') }
    let!(:course) { Course.create!(course_name: 'Test Course', canvas_id: '123') }
    let!(:course_to_lms) { CourseToLms.create!(course: course, lms_id: 1, external_course_id: '123') }
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

        expect(response).to have_http_status(:unprocessable_content)
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

  describe 'PATCH #bulk_update_enabled' do
    let!(:user) { User.create!(name: 'Test User', email: 'bulk-test@example.com') }
    let!(:course) { Course.create!(course_name: 'Bulk Test Course', canvas_id: '456') }
    let!(:course_to_lms) { CourseToLms.create!(course: course, lms_id: 1, external_course_id: '456') }
    let!(:course_settings) { CourseSettings.create!(course: course, enable_extensions: true) }
    let!(:assignment_with_due_date) do
      Assignment.create!(
        name: 'Assignment With Due Date',
        course_to_lms: course_to_lms,
        due_date: 3.days.from_now,
        external_assignment_id: 'with-date-1',
        enabled: false
      )
    end
    let!(:another_assignment_with_due_date) do
      Assignment.create!(
        name: 'Another Assignment With Due Date',
        course_to_lms: course_to_lms,
        due_date: 5.days.from_now,
        external_assignment_id: 'with-date-2',
        enabled: false
      )
    end
    let!(:assignment_without_due_date) do
      Assignment.create!(
        name: 'Assignment Without Due Date',
        course_to_lms: course_to_lms,
        due_date: nil,
        external_assignment_id: 'no-date-1',
        enabled: false
      )
    end

    context 'when the user is an instructor' do
      it 'enables all assignments with a due date and skips those without' do
        patch :bulk_update_enabled, params: { course_id: course.id, enabled: true, role: 'instructor', user_id: user.id }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body['success']).to be true
        expect(body['enabled']).to be true
        expect(body['updated_count']).to eq(2)
        expect(body['skipped_count']).to eq(1)

        expect(assignment_with_due_date.reload.enabled).to be true
        expect(another_assignment_with_due_date.reload.enabled).to be true
        expect(assignment_without_due_date.reload.enabled).to be false
      end

      it 'disables all assignments regardless of due date' do
        assignment_with_due_date.update!(enabled: true)
        another_assignment_with_due_date.update!(enabled: true)

        patch :bulk_update_enabled, params: { course_id: course.id, enabled: false, role: 'instructor', user_id: user.id }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body['success']).to be true
        expect(body['enabled']).to be false
        expect(body['updated_count']).to eq(3)
        expect(body['skipped_count']).to eq(0)

        expect(assignment_with_due_date.reload.enabled).to be false
        expect(another_assignment_with_due_date.reload.enabled).to be false
        expect(assignment_without_due_date.reload.enabled).to be false
      end
    end

    context 'when the user is not an instructor' do
      it 'returns a forbidden status and does not change any assignments' do
        patch :bulk_update_enabled, params: { course_id: course.id, enabled: true, role: 'student', user_id: user.id }

        expect(response).to have_http_status(:forbidden)
        expect(assignment_with_due_date.reload.enabled).to be false
        expect(another_assignment_with_due_date.reload.enabled).to be false
      end
    end

    context 'when the course does not exist' do
      it 'returns a not found status' do
        patch :bulk_update_enabled, params: { course_id: -1, enabled: true, role: 'instructor', user_id: user.id }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
