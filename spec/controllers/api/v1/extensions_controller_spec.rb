require 'rails_helper'
module Api
  module V1
    RSpec.describe ExtensionsController, type: :controller do
      let(:mock_course_id) { 16 }
      let(:mock_assignment_id) { 9 }
      let(:mock_extension_id) { 5 }
      let(:mock_student_id) { 123 }
      let(:mock_reason) { 'extra time needed' }
      let(:mock_new_due_date) { '2023-12-25' }

      before do
        request.headers.merge!({'Authorization' => 'Bearer some_valid_token'})
      end

      describe 'POST #create' do
        context 'with valid parameters' do
          it 'creates a new extension and returns a success status' do
            post :create, params: {
              course_id: mock_course_id,
              assignment_id: mock_assignment_id,
              student_id: mock_student_id,
              reason: mock_reason,
              new_due_date: mock_new_due_date,
            }
            expect(response).to have_http_status(:success)
          end
        end

        context 'with invalid parameters' do
          it 'returns an error status' do
            post :create, params: {}
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      describe 'GET #index' do
        it 'returns a list of extensions' do
          get :index, params: {
            course_id: mock_course_id,
            assignment_id: mock_assignment_id
          }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to be_an_instance_of(Array)
        end
      end

      describe 'DELETE #destroy' do
        it 'deletes an extension and returns a success status' do
          delete :destroy, params: {
            course_id: mock_course_id,
            assignment_id: mock_assignment_id,
            id: mock_extension_id
          }
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
