require 'rails_helper'
module Api
  module V1
    describe CoursesController do
      describe 'create' do
        context 'when the course is created successfully' do
          it 'creates a course and flashes a success message' do
            post :create, params: { course_name: 'New Course' }

            expect(response).to have_http_status(:created)
            expect(flash[:success]).to eq("Course created successfully")
            expect(JSON.parse(response.body)['course_name']).to eq('New Course')
          end
        end

        context 'when course with same name already exists' do
          before do
            Course.create(course_name: 'Existing Course')
          end

          it 'returns a message letting the user know the course already exists' do
            post :create, params: { course_name: 'Existing Course' }

            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)['message']).to eq('A course with the same course name already exists.')
          end
        end

        context 'when the course creation fails' do
          it 'returns an error flash message when course creation fails' do
            # Force a failure by creating a non-persisted instance
            allow(Course).to receive(:create).and_return(Course.new)

            post :create, params: { course_name: '' } # Example invalid parameter

            expect(response).to have_http_status(:unprocessable_entity)
            expect(flash.now[:error]).to eq("Failed to create course")
            expect(JSON.parse(response.body)['message']).to eq("Course creation failed")
          end
        end
      end

      describe 'index' do
        it 'throws a 501 error' do
          get :index
          expect(response.status).to eq(501)
        end
      end

      describe 'destroy' do
        it 'throws a 501 error' do
          delete :destroy, params: { id: 16 }
          expect(response.status).to eq(501)
        end
      end

      describe 'add_user' do
        it 'throws a 501 error' do
          put :add_user, params: { course_id: 16, user_id: 16 }
          expect(response.status).to eq(501)
        end
      end
    end
  end
end
