require 'rails_helper'
require 'lms_api'

RSpec.describe "Bcourses", type: :request do
  describe 'GET /index' do
    let(:canvas_api_key) { 'test_api_key' } 
    let(:api_mock) { instance_double('LMS::Canvas') }
    let(:courses) { [{'name' => 'Course 1'}, {'name' => 'Course 2'}] }
    
    before do
      allow(Rails.application.credentials).to receive(:dig).with(:development, :canvas, :dev_api_key).and_return(canvas_api_key)
      allow(LMS::Canvas).to receive(:new).with("https://bcourses.berkeley.edu", canvas_api_key).and_return(api_mock)
      allow(api_mock).to receive(:api_get_request).and_return(courses)
    end

    context 'when API call is successful' do
      it 'renders the index template with courses' do
        get bcourses_path
        expect(response).to be_successful
        puts response.body
        expect(response.body).to include('Course 1')
        expect(response.body).to include('Course 2')
      end
    end

    context 'when API call fails' do
      let(:error_message) { "Failed to fetch courses: Error" }
      before do
        allow(api_mock).to receive(:api_get_request).and_raise(StandardError, 'Error')
      end

      it 'renders the index template with an error message' do
        get bcourses_path
        expect(response).to be_successful
        expect(response.body).to include(error_message)
      end
    end
  end
end