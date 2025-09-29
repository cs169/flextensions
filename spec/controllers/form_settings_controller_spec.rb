require 'rails_helper'

RSpec.describe FormSettingsController, type: :controller do
  let(:user) { User.create!(email: 'instructor@example.com', canvas_uid: '12345', name: 'Instructor') }
  let(:course) { Course.create!(course_name: 'Algorithms', canvas_id: '789', course_code: 'CS101') }
  let(:user_to_course) { UserToCourse.create!(user: user, course: course, role: 'teacher') }
  let(:valid_params) do
    {
      course_id: course.id,
      form_setting: {
        reason_desc: 'Updated reason',
        documentation_desc: 'Provide docs',
        documentation_disp: 'required',
        custom_q1: 'Q1?',
        custom_q1_desc: 'Desc 1',
        custom_q1_disp: 'optional',
        custom_q2: 'Q2?',
        custom_q2_desc: 'Desc 2',
        custom_q2_disp: 'optional'
      }
    }
  end

  before do
    session[:user_id] = user.canvas_uid
    allow_any_instance_of(Course).to receive(:user_role).and_return('instructor')
    course.create_form_setting!(
      documentation_disp: 'hidden',
      custom_q1_disp: 'optional',
      custom_q2_disp: 'optional'
    )
  end

  describe 'GET #edit' do
    context 'when logged in and course exists' do
      it 'renders the edit form setting page' do
        get :edit, params: { course_id: course.id }
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
        expect(assigns(:form_setting)).to eq(course.form_setting)
      end
    end

    context 'when course is not found' do
      it 'redirects to courses_path with alert' do
        get :edit, params: { course_id: '999' }
        expect(response).to redirect_to(courses_path)
        expect(flash[:alert]).to eq('Course not found.')
      end
    end

    context 'when not logged in' do
      before { session[:user_id] = 'non_existent_id' }

      it 'redirects to root_path' do
        get :edit, params: { course_id: course.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You must be logged in to access that page.')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the form setting and redirects' do
        patch :update, params: valid_params
        expect(response).to redirect_to(edit_course_form_setting_path(course))
        expect(flash[:notice]).to eq('Form settings updated successfully.')
        expect(course.form_setting.reload.reason_desc).to eq('Updated reason')
      end
    end

    context 'with invalid params (enum)' do
      let(:invalid_params) do
        {
          course_id: course.id,
          form_setting: {
            documentation_disp: 'invalid', # not in enum
            custom_q1_disp: 'optional',
            custom_q2_disp: 'optional'
          }
        }
      end

      it 're-renders the edit template' do
        patch :update, params: invalid_params
        expect(response).to render_template(:edit)
        expect(assigns(:form_setting).errors[:documentation_disp]).to include('is not included in the list')
      end
    end

    context 'when course not found' do
      it 'redirects to courses_path with alert' do
        patch :update, params: {
          course_id: '999',
          form_setting: { documentation_disp: 'hidden', custom_q1_disp: 'hidden', custom_q2_disp: 'hidden' }
        }
        expect(response).to redirect_to(courses_path)
        expect(flash[:alert]).to eq('Course not found.')
      end
    end

    context 'when not logged in' do
      before { session[:user_id] = 'non_existent_id' }

      it 'redirects to root_path' do
        patch :update, params: {
          course_id: course.id,
          form_setting: { documentation_disp: 'hidden', custom_q1_disp: 'hidden', custom_q2_disp: 'hidden' }
        }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You must be logged in to access that page.')
      end
    end

    context 'when user is a student' do
      before do
        allow_any_instance_of(Course).to receive(:user_role).and_return('student')
      end

      it 'denies access and redirects to courses path' do
        patch :update, params: valid_params
        expect(response).to redirect_to(courses_path)
        expect(flash[:alert]).to eq('You do not have access to this page.')
      end
    end
  end
end
