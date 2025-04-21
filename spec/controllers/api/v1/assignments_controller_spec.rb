require 'rails_helper'
module Api
  module V1
    describe AssignmentsController do
      def json_response
        response.parsed_body
      end

      let(:mock_course) { Course.create!(course_name: 'Test Course') }
      let(:mock_lms) { Lms.create!(lms_name: 'Test LMS') }
      let(:mock_course_to_lms) { CourseToLms.create!(course_id: mock_course.id, lms_id: mock_lms.id) }

      let(:valid_params) { { name: 'Test Assignment', external_assignment_id: '123ABC', course_id: mock_course.id, lms_id: mock_lms.id } }

      before do
        mock_course
        mock_lms
        mock_course_to_lms
        allow(controller).to receive(:authenticated!).and_return(true)
      end

      after do
        LmsCredential.destroy_all
        Extension.destroy_all
        Assignment.destroy_all
        CourseToLms.destroy_all
        UserToCourse.destroy_all
        Course.destroy_all
        Lms.destroy_all
        User.destroy_all
      end

      describe 'GET /api/v1/courses/:course_id/lmss/:lms_id/assignments' do
        it 'throws a 501 error' do
          get :index, params: { course_id: mock_course.id, lms_id: mock_lms.id }
          expect(response).to have_http_status(501)
        end
      end

      describe 'POST /api/v1/courses/:course_id/lmss/:lms_id/assignments' do
        context 'when one or more parameters are missing' do
          it 'returns status :bad_request when name is missing' do
            post :create, params: valid_params.except(:name)
            expect(response).to have_http_status(:bad_request)
            expect(json_response['error']).to include('param is missing or the value is empty: name')
          end
        end

        context 'when course_id or lms_id are not integers' do
          it 'returns status :bad_request if course_id is not an integer' do
            post :create, params: valid_params.merge(course_id: 'abc')
            expect(response).to have_http_status(:bad_request)
            expect(json_response['error']).to include('course_id and lms_id must be integers')
          end

          it 'returns status :bad_request if lms_id is not an integer' do
            post :create, params: valid_params.merge(lms_id: 'xyz')
            expect(response).to have_http_status(:bad_request)
            expect(json_response['error']).to include('course_id and lms_id must be integers')
          end
        end

        context 'save is unsuccessful' do
          it 'returns status :unprocessable_entity' do
            allow_any_instance_of(Assignment).to receive(:save).and_return(false)
            post :create, params: valid_params
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'when valid parameters are provided' do
          it 'creates a new assignment and returns status :created' do
            post :create, params: valid_params
            expect(response).to have_http_status(:created)
            expect(json_response['name']).to eq(valid_params[:name])
            expect(json_response['external_assignment_id']).to eq(valid_params[:external_assignment_id])
          end
        end

        context 'when course_to_lms does not exist' do
          it 'returns status :not_found' do
            # Ensure this course_to_lms does not exist
            selected_course = CourseToLms.find_by(course_id: 1, lms_id: 1)
            selected_course&.destroy
            post :create, params: { course_id: 1, lms_id: 1, name: 'Test Assignment', external_assignment_id: '123ABC' }
            expect(response).to have_http_status(:not_found)
            expect(response.body).to include('No such Course_LMS association')
          end
        end

        context 'when the assignment already exists' do
          it 'returns status :ok' do
            Assignment.create!(course_to_lms_id: mock_course_to_lms.id, name: 'Test Assignment', external_assignment_id: '123ABC')
            post :create, params: valid_params
            expect(response).to have_http_status(:ok)
            expect(response.body).to include('Record already exists')
          end
        end
      end

      describe 'DELETE /api/v1/courses/:course_id/lmss/:lms_id/assignments/:id' do
        let(:mock_assignment_id) { 1 }

        it 'throws a 501 error' do
          delete :destroy, params: { course_id: mock_course.id, lms_id: mock_lms.id, id: mock_assignment_id }
          expect(response).to have_http_status(501)
        end
      end
    end
  end
end
