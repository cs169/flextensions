require 'rails_helper'

RSpec.describe UserToCoursesController, type: :controller do
  let(:instructor) { User.create!(email: 'instructor@example.com', canvas_uid: '100', name: 'Instructor') }
  let(:student_user) { User.create!(email: 'student@example.com', canvas_uid: '200', name: 'Student') }
  let(:course) { Course.create!(course_name: 'Test Course', canvas_id: '456', course_code: 'TST101') }
  let(:student_enrollment) { UserToCourse.create!(user: student_user, course: course, role: 'student') }

  describe 'PATCH #toggle_allow_extended_requests' do
    context 'when user is an instructor' do
      before do
        UserToCourse.create!(user: instructor, course: course, role: 'teacher')
        student_enrollment
        session[:user_id] = instructor.canvas_uid
        instructor.lms_credentials.create!(
          lms_name: 'canvas',
          token: 'fake_token',
          refresh_token: 'fake_refresh_token',
          expire_time: 1.hour.from_now
        )
      end

      it 'successfully enables allow_extended_requests' do
        patch :toggle_allow_extended_requests, params: {
          course_id: course.id,
          id: student_enrollment.id,
          allow_extended_requests: true
        }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq({ 'success' => true })
        expect(student_enrollment.reload.allow_extended_requests).to be true
      end

      it 'successfully disables allow_extended_requests' do
        student_enrollment.update!(allow_extended_requests: true)

        patch :toggle_allow_extended_requests, params: {
          course_id: course.id,
          id: student_enrollment.id,
          allow_extended_requests: false
        }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq({ 'success' => true })
        expect(student_enrollment.reload.allow_extended_requests).to be false
      end

      it 'returns unprocessable_entity when update fails' do
        errors = ActiveModel::Errors.new(student_enrollment)
        errors.add(:base, 'Validation failed')
        allow_any_instance_of(UserToCourse).to receive(:update).and_return(false)
        allow_any_instance_of(UserToCourse).to receive(:errors).and_return(errors)

        patch :toggle_allow_extended_requests, params: {
          course_id: course.id,
          id: student_enrollment.id,
          allow_extended_requests: true
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['redirect_to']).to be_present
      end
    end

    context 'when user is a student' do
      before do
        student_enrollment
        session[:user_id] = student_user.canvas_uid
        student_user.lms_credentials.create!(
          lms_name: 'canvas',
          token: 'fake_token',
          refresh_token: 'fake_refresh_token',
          expire_time: 1.hour.from_now
        )
      end

      it 'returns forbidden status' do
        patch :toggle_allow_extended_requests, params: {
          course_id: course.id,
          id: student_enrollment.id,
          allow_extended_requests: true
        }

        expect(response).to have_http_status(:forbidden)
        expect(response.parsed_body['redirect_to']).to be_present
      end

      it 'does not update the enrollment' do
        patch :toggle_allow_extended_requests, params: {
          course_id: course.id,
          id: student_enrollment.id,
          allow_extended_requests: true
        }

        expect(student_enrollment.reload.allow_extended_requests).to be false
      end
    end

    context 'when course does not exist' do
      before do
        student_enrollment
        session[:user_id] = instructor.canvas_uid
        instructor.lms_credentials.create!(
          lms_name: 'canvas',
          token: 'fake_token',
          refresh_token: 'fake_refresh_token',
          expire_time: 1.hour.from_now
        )
      end

      it 'redirects to courses_path with alert' do
        patch :toggle_allow_extended_requests, params: {
          course_id: 9999,
          id: student_enrollment.id,
          allow_extended_requests: true
        }

        expect(response).to redirect_to(courses_path)
        expect(flash[:alert]).to eq('Course not found.')
      end
    end

    context 'when enrollment does not exist' do
      before do
        UserToCourse.create!(user: instructor, course: course, role: 'teacher')
        session[:user_id] = instructor.canvas_uid
        instructor.lms_credentials.create!(
          lms_name: 'canvas',
          token: 'fake_token',
          refresh_token: 'fake_refresh_token',
          expire_time: 1.hour.from_now
        )
      end

      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          patch :toggle_allow_extended_requests, params: {
            course_id: course.id,
            id: 9999,
            allow_extended_requests: true
          }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
