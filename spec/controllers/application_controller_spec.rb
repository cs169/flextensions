# spec/controllers/application_controller_spec.rb
require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'OK'
    end
    def test_auth
      authenticated!
    end
  end

  let(:user) do
    User.create!(email: 'test@example.com', canvas_uid: '123').tap do |u|
      u.lms_credentials.create!(
        lms_name: 'canvas',
        token: 'valid_token',
        refresh_token: 'refresh_token',
        expire_time: 1.hour.from_now
      )
    end
  end

  before do
    routes.draw { get 'index' => 'anonymous#index' }
  end

  describe '#excluded_controller_action?' do
    {
      'home' => 'index',
      'login' => 'canvas',
      'session' => 'create',
      'rails/health' => 'show'
    }.each do |controller, action|
      it "excludes #{controller}##{action} from authentication" do
        allow_any_instance_of(ApplicationController).to receive(:params)
          .and_return({ controller: controller, action: action })

        expect(subject.excluded_controller_action?).to be true
      end
    end

    it 'does not exclude unknown controller/action' do
      allow(controller).to receive(:params).and_return({ controller: 'courses', action: 'index' })
    
      expect(controller.send(:excluded_controller_action?)).to be nil
    end
    
  end

  describe '#authenticated!' do
    before do
      allow(Rails.env).to receive(:test?).and_return(false)
    end
    context 'when in test environment' do
      it 'returns true if session user_id is set' do
        allow(Rails.env).to receive(:test?).and_return(true)
        session[:user_id] = 'some-id'

        get :index
        expect(response.body).to eq('OK')
      end
    end

    context 'when user is not found' do
      it 'resets session and redirects with alert' do
        session[:user_id] = 'nonexistent-id'
        
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('User not found in the database.')
      end
    end


    context 'when user token has expired' do
      it 'resets session and redirects with alert' do
        user.lms_credentials.first.update!(expire_time: 1.hour.ago)
        session[:user_id] = user.canvas_uid

        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('User token has expired.')
      end
    end

    context 'when token is valid' do
      it 'continues to requested action' do
        session[:user_id] = user.canvas_uid

        get :index
        expect(response.body).to eq('OK')
      end
    end
  end
end
