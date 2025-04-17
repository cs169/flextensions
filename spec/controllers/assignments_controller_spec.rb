# spec/controllers/assignments_controller_spec.rb
require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do
  before do
    session[:user_id] = '123'
  end
  describe 'POST #toggle_enabled' do
    let!(:course) { Course.create!(course_name: 'Test Course', canvas_id: '123') }
    let!(:lms) { Lms.create!(lms_name: 'Canvas', use_auth_token: true) }
    let!(:course_to_lms) { CourseToLms.create!(course: course, lms: lms, external_course_id: '123') }
    let!(:assignment) do
      Assignment.create!(
        name: 'Test Assignment',
        course_to_lms: course_to_lms,
        external_assignment_id: 'abc123',
        enabled: false
      )
    end

    it 'updates the enabled status to true' do
      post :toggle_enabled, params: { id: assignment.id, enabled: true }

      expect(response).to have_http_status(:ok)
      expect(assignment.reload.enabled).to be true
    end

    it 'updates the enabled status to false' do
      assignment.update!(enabled: true)

      post :toggle_enabled, params: { id: assignment.id, enabled: false }

      expect(response).to have_http_status(:ok)
      expect(assignment.reload.enabled).to be false
    end
  end
end
