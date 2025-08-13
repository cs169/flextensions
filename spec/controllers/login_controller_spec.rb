require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  # TODO: Remove login controller and move logout to session controller.
  # let(:encoded_scopes) { CGI.escape(CanvasFacade::CANVAS_API_SCOPES) }

  # describe 'GET #canvas' do
  #   it 'redirects to canvas authorization URL' do
  #     allow(ENV).to receive(:fetch).with('CANVAS_CLIENT_ID', nil).and_return('test_client_id')
  #     allow(ENV).to receive(:fetch).with('CANVAS_REDIRECT_URI', nil).and_return('http://localhost:3000')
  #     allow(ENV).to receive(:fetch).with('CANVAS_URL', nil).and_return('https://ucberkeleysandbox.instructure.com')

  #     get :canvas

  #     expected_url = 'https://ucberkeleysandbox.instructure.com/login/oauth2/auth?'
  #     expect(response).to redirect_to(/^#{Regexp.escape(expected_url)}/)
  #     expect(response.location).to include('client_id=test_client_id')
  #     expect(response.location).to include('response_type=code')
  #     expect(response.location).to include('redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth%2Fcanvas%2Fcallback')
  #     expect(response.location).to include(encoded_scopes)
  #   end
  # end

  describe 'GET #logout' do
    before do
      session[:user_id] = 'test_user_id'
      session[:username] = 'test_username'
    end

    it 'clears the session and redirects to root path' do
      get :logout
      expect(session[:user_id]).to be_nil
      expect(session[:username]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end

  # describe '#canvas_authorize_url' do
  #   it 'builds the correct canvas authorization URL' do
  #     allow(ENV).to receive(:fetch).with('CANVAS_CLIENT_ID', nil).and_return('test_client_id')
  #     allow(ENV).to receive(:fetch).with('CANVAS_REDIRECT_URI', nil).and_return('http://localhost:3000')
  #     allow(ENV).to receive(:fetch).with('CANVAS_URL', nil).and_return('https://ucberkeleysandbox.instructure.com')

  #     url = controller.send(:canvas_authorize_url) # send to test private method

  #     expect(url).to start_with('https://ucberkeleysandbox.instructure.com/login/oauth2/auth?')
  #     expect(url).to include('client_id=test_client_id')
  #     expect(url).to include('response_type=code')
  #     expect(url).to include('redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth%2Fcanvas%2Fcallback')
  #     expect(url).to include(encoded_scopes)
  #   end
  # end
end
