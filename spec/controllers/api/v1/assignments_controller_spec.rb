require 'rails_helper'
module Api
  module V1
    RSpec.describe AssignmentsController do
      def json_response
        JSON.parse(response.body)
      end

      let(:mock_course) { Course.create!(course_name: "Test Course") }
      let(:mock_lms) { Lms.create!(lms_name: "Test LMS") }
      let(:mock_course_to_lms) { CourseToLms.create!(course_id: mock_course.id, lms_id: mock_lms.id) }

      let(:valid_params) { { name: "Test Assignment", external_assignment_id: "123ABC", course_id: mock_course.id, lms_id: mock_lms.id } }
      
      before do
        mock_course
        mock_lms
        mock_course_to_lms
      end

      after do
        Assignment.delete_all
        CourseToLms.delete_all
        Course.delete_all
        Lms.delete_all
      end

      describe "GET /api/v1/courses/:course_id/lmss/:lms_id/assignments" do
        it "throws a 501 error" do
          get :index, params: { course_id: mock_course.id, lms_id: mock_lms.id }
          expect(response).to have_http_status(501)
        end
      end

      describe "POST /api/v1/courses/:course_id/lmss/:lms_id/assignments" do
        context 'when valid parameters are provided' do
          it 'creates a new assignment and returns status :created' do
            post :create, params: valid_params
            expect(response).to have_http_status(:created)
            expect(json_response["name"]).to eq(valid_params[:name])
            expect(json_response["external_assignment_id"]).to eq(valid_params[:external_assignment_id])
          end
        end

        context 'when course_to_lms does not exist' do
          it 'returns status :not_found' do
            post :create, params: { course_id: -1, lms_id: -1, name: "Test Assignment", external_assignment_id: "123ABC" }
            expect(response).to have_http_status(:not_found)
            expect(response.body).to include('Course to LMS association not found')
          end
        end

        context 'when the assignment already exists' do
          it 'returns status :ok' do
            Assignment.create!(course_to_lms_id: mock_course_to_lms.id, name: "Test Assignment", external_assignment_id: "123ABC")
            post :create, params: valid_params
            expect(response).to have_http_status(:ok)
            expect(response.body).to include('The assignment with the specified external ID already exists.')
          end
        end



      end

      describe "DELETE /api/v1/courses/:course_id/lmss/:lms_id/assignments/:id" do
        let(:mock_assignment_id) { 1 }
        it "throws a 501 error" do
          delete :destroy, params: { course_id: mock_course.id, lms_id: mock_lms.id, id: mock_assignment_id }
          expect(response).to have_http_status(501)
        end
      end
    end
  end
end
