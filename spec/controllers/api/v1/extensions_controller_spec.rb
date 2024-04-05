require 'rails_helper'
module Api
  module V1
    describe ExtensionsController do
      let(:mock_course_id) { 16 }
      let(:mock_lms_id) { 1 }
      let(:mock_assignment_id) { 9 }
      let(:mock_extension_id) {5}

      

    ### TODO: check that it's properly handling post body as well as params.
      describe 'create' do
        it 'throws a 501 error' do
          post :create, params: {
            course_id: :mock_course_id,
            lmss_id: :mock_lms_id,
            assignment_id: :mock_assignment_id
          }
          expect(response.status).to eq(501)
        end
    end
    describe 'index' do
      it 'throws a 501 error' do
        post :index, params: {
          course_id: :mock_course_id,
          lmss_id: :mock_lms_id,
          assignment_id: :mock_assignment_id
        }
        expect(response.status).to eq(501)
      end
  end
  describe 'destroy' do
    it 'throws a 501 error' do
      delete :delete, params: {
        course_id: :mock_course_id,
        lmss_id: :mock_lms_id,
        assignment_id: :mock_assignment_id,
        extension_id: :mock_extension_id
      }
      expect(response.status).to eq(501)
    end
end
    end
  end
end