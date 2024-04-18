require 'rails_helper'
module Api
  module V1
    RSpec.describe ExtensionsController, type: :request do
      let(:mock_course_id) { 16 }
      let(:mock_lms_id) { 1 }
      let(:mock_assignment_id) { 9 }
      let(:mock_extension_id) { 5 }
      let(:mock_student_uid) { 123 }
      let(:mock_reason) { 'extra time needed' }
      let(:mock_new_due_date) { '2023-12-25' }

      # POST /api/v1/courses/:course_id/lmss/:lms_id/assignments/:assignment_id/extensions
      describe "POST /api/v1/courses/:course_id/lmss/:lms_id/assignments/:assignment_id/extensions" do
        context "with valid parameters" do
          it "creates a new extension and returns a success status" do
            post "/api/v1/courses/#{mock_course_id}/lmss/#{mock_lms_id}/assignments/#{mock_assignment_id}/extensions", params: {
              student_uid: mock_student_uid,
              reason: mock_reason,
              new_due_date: mock_new_due_date
            }, headers: { 'Authorization' => 'Bearer some_valid_token' }
            expect(response).to have_http_status(:success)
          end
        end

        context "with invalid parameters" do
          it "returns an error status" do
            post "/api/v1/courses/#{mock_course_id}/lmss/#{mock_lms_id}/assignments/#{mock_assignment_id}/extensions", params: {}, headers: { 'Authorization' => 'Bearer some_valid_token' }
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      # GET /api/v1/courses/:course_id/lmss/:lms_id/assignments/:assignment_id/extensions
      describe "GET /api/v1/courses/:course_id/lmss/:lms_id/assignments/:assignment_id/extensions" do
        it "returns a list of extensions" do
          get "/api/v1/courses/#{mock_course_id}/lmss/#{mock_lms_id}/assignments/#{mock_assignment_id}/extensions", headers: { 'Authorization' => 'Bearer some_valid_token' }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to be_an_instance_of(Array)
        end
      end

      # DELETE /api/v1/courses/:course_id/lmss/:lms_id/assignments/:assignment_id/extensions/:id
      describe "DELETE /api/v1/courses/#{mock_course_id}/lmss/#{mock_lms_id}/assignments/#{mock_assignment_id}/extensions/:id" do
        it "deletes an extension and returns a success status" do
          delete "/api/v1/courses/#{mock_course_id}/lmss/#{mock_lms_id}/assignments/#{mock_assignment_id}/extensions/#{mock_extension_id}", headers: { 'Authorization' => 'Bearer some_valid_token' }
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
