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
    allow(controller).to receive_messages(courses_path: '/courses', root_path: '/')
  end

  describe '#excluded_controller_action?' do
    subject(:controller_instance) { controller }

    {
      'home' => 'index',
      'login' => 'canvas',
      'session' => 'create',
      'rails/health' => 'show'
    }.each do |controller, action|
      it "excludes #{controller}##{action} from authentication" do
        allow_any_instance_of(described_class).to receive(:params)
          .and_return({ controller: controller, action: action })

        expect(controller_instance.excluded_controller_action?).to be true
      end
    end

    it 'does not exclude unknown controller/action' do
      allow(controller).to receive(:params).and_return({ controller: 'courses', action: 'index' })

      expect(controller.send(:excluded_controller_action?)).to be_nil
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
        expect(flash[:alert]).to eq('You must be logged in to access that page.')
      end
    end

    context 'when user token has expired' do
      it 'resets session and redirects with alert' do
        user.lms_credentials.first.update!(expire_time: 1.hour.ago)
        session[:user_id] = user.canvas_uid

        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You have been logged out.')
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

  describe '#render_role_based_view' do
    before do
      allow(controller).to receive_messages(controller_name: controller_name_override, action_name: action_name_override)
    end

    context 'as a student on courses#show' do
      let(:controller_name_override) { 'courses' }
      let(:action_name_override)     { 'show' }

      before do
        controller.instance_variable_set(:@role, 'student')
      end

      it 'renders courses/student_show' do
        expect(controller).to receive(:render).with('courses/student_show')
        controller.send(:render_role_based_view)
      end
    end

    context 'as an instructor on requests#index' do
      let(:controller_name_override) { 'requests' }
      let(:action_name_override)     { 'index' }

      before do
        controller.instance_variable_set(:@role, 'instructor')
      end

      it 'renders requests/instructor_index' do
        expect(controller).to receive(:render).with('requests/instructor_index')
        controller.send(:render_role_based_view)
      end
    end

    context 'with explicit controller and view overrides' do
      let(:controller_name_override) { 'courses' }
      let(:action_name_override)     { 'show' }

      before do
        controller.instance_variable_set(:@role, 'student')
      end

      it 'renders the overridden student view under requests' do
        expect(controller).to receive(:render).with('requests/student_show')
        controller.send(:render_role_based_view, controller: 'requests', view: 'show')
      end
    end

    context 'when @role is nil or unrecognized' do
      let(:controller_name_override) { 'courses' }
      let(:action_name_override)     { 'show' }

      before do
        controller.instance_variable_set(:@role, nil)
      end

      it 'redirects to courses_path with an alert' do
        expect(controller).to receive(:redirect_to).with('/courses', alert: 'You do not have access to this view.')
        controller.send(:render_role_based_view)
      end
    end
  end
end
