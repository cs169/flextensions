require 'rails_helper'
module Api
  module V1
    describe CoursesController do
      describe 'POST #create' do
        context "when a course with the same name does not exist and the course is successfully created" do
          let(:course_name) { "New Course" }
          
          it "creates and saves a new course" do
            post :create, params: { course_name: course_name }
  
            expect(response).to have_http_status(:created)
            expect(Course.find_by(course_name: course_name)).to be_present
            expect(flash[:success]).to eq("Course created successfully")
            expect(JSON.parse(response.body)['course_name']).to eq('New Course')
          end
        end
  
        context "when a course with the same name already exists" do
          let!(:existing_course) { Course.create(course_name: "Existing Course") }
  
          it "does not create a new course and returns an error" do
            post :create, params: { course_name: existing_course.course_name }
  
            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({ "message" => "A course with the same course name already exists." })
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
