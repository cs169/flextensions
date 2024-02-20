require 'rails_helper'

RSpec.describe BcoursesController, type: :controller do
  describe 'GET #index' do
    let(:canvas_api_key) { 'test_api_key' } 
    let(:api_mock) { instance_double('LMS::Canvas') }
    let(:courses) { [{'name' => 'Course 1'}, {'name' => 'Course 2'}] }
    
    before do
      # Simulate fetching the API key from credentials
      allow(Rails.application.credentials).to receive(:dig).with(:development, :canvas, :dev_api_key).and_return(canvas_api_key)
      # Stub the LMS::Canvas initialization to return a mock object
      allow(LMS::Canvas).to receive(:new).with("https://bcourses.berkeley.edu", canvas_api_key).and_return(api_mock)
      # Stub the api_get_request method to return predefined courses
      allow(api_mock).to receive(:api_get_request).and_return(courses)
    end

    context 'when API call is successful' do
      it 'assigns @courses and renders the index template' do
        get :index
        expect(assigns(:courses)).to eq(courses)
        expect(response).to render_template(:index)
      end
    end

    context 'when API call fails' do
      let(:error_message) { "Failed to fetch courses: Error" }
      
      before do
        # Make the api_get_request method raise an error to simulate a failure
        allow(api_mock).to receive(:api_get_request).and_raise(StandardError, 'Error')
      end

      it 'assigns @error' do
        get :index
        expect(assigns(:error)).to eq(error_message)
      end
    end
  end
end
