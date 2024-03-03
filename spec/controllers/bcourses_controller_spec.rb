require 'rails_helper'
require 'lms_api'

RSpec.describe "Bcourses", type: :request do
  describe 'GET /index' do
    let(:canvas_api_key) { 'test_api_key' } 
    let(:api_mock) { instance_double('LMS::Canvas') }
    let(:courses) { [{'name' => 'Course 1'}, {'name' => 'Course 2'}] }
    
    before do

      # Stub to return the URL
      allow(Rails.application.credentials).to receive(:dig).with(:test, :canvas, :url).and_return("https://ucberkeley.test.instructure.com")
      # Stub to return the API key
      allow(Rails.application.credentials).to receive(:dig).with(:test, :canvas, :dev_api_key).and_return('test_api_key')
      allow(LMS::Canvas).to receive(:new).and_return(api_mock)
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

    context 'when token is expired' do
      let(:error_message) { "Token expired and needs refresh" }
      before do
        allow(api_mock).to receive(:api_get_request).and_raise(LMS::Canvas::RefreshTokenRequired, 'Refresh token required')
      end

      it 'renders the index template with a token refresh error message' do
        get bcourses_path
        expect(response).to be_successful
        expect(response.body).to include(error_message)
      end
    end

    context 'when there is a network connection error' do
      let(:error_message) { "Network connection error" }
      before do
        allow(api_mock).to receive(:api_get_request).and_raise(SocketError, 'Connection refused')
      end

      it 'renders the index template with a network error message' do
        get bcourses_path
        expect(response).to be_successful
        expect(response.body).to include(error_message)
      end
    end

    context 'when API call fails due to a StandardError (Unexpected Error)' do
      let(:error_message) { "An unexpected error occurred: Error" }
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