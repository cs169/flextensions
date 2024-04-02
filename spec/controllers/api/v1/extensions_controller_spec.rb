require 'rails_helper'
module Api
  module V1
    describe LmssController do
      let(:mock_course_id) { 16 }
      let(:mock_lms_name) { 'testCourseName' }
      let(:mock_assignment_id) { 9 }

      ### TODO: check that it's properly handling post body as well as params.
      describe 'create' do
        it 'throws a 501 error' do
          post :create, params: {
            course_id: :mock_course_id,
            lms_name: :mock_course_name,
            assignment_id: :mock_assignment_id
          }
          expect(response.status).to eq(501)
        end
      describe 'index' do
        it 'throws a 501 error' do
          get :index, params: { 
            course_id: :mock_course_id,
            lms_name: :mock_course_name,
            assignment_id: :mock_assignment_id
           }
          expect(response.status).to eq(501)
        end
      end

        end
      end
    end
  end
end