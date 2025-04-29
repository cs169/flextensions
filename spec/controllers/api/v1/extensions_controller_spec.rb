require 'rails_helper'
require 'byebug'
module Api
  module V1
    describe ExtensionsController do
      describe 'POST /api/v1/courses/:course_id/lmss/:lms_id/assignments/:assignment_id/extensions' do
        before(:all) do
          @user = User.find_or_create_by!(name: 'Test User', email: 'test@example.com')
          @course = Course.find_or_create_by!(course_name: 'Test Course', canvas_id: '12345')
          @lms = Lms.find_or_create_by!(lms_name: 'Canvas', use_auth_token: true)
          @course_to_lms = CourseToLms.find_or_create_by!(course: @course, lms: @lms, external_course_id: '67890')
          @assignment = Assignment.find_or_create_by!(
            name: 'Test Assignment',
            course_to_lms: @course_to_lms,
            external_assignment_id: '11111'
          )
          @extension = Extension.find_or_create_by!(
            assignment: @assignment,
            last_processed_by_id: @user.id, # Use the correct column
            new_due_date: '2024-04-16T16:00:00Z'
          )

          @mock_student_uid = 123
          @mock_new_due_date = '2024-04-16T16:00:00Z'
          @auth_token = 'some_valid_token'
          @mock_assignments_url = "#{ENV.fetch('CANVAS_URL', nil)}/api/v1/courses/#{@course_to_lms.external_course_id}/assignments"
          @mock_override_url = "#{@mock_assignments_url}/#{@assignment.external_assignment_id}/overrides"
        end

        context 'with valid parameters' do
          it 'creates a new extension and returns a success status' do
            stub_request(:post, @mock_override_url)
              .with(
                body: {
                  assignment_override: hash_including({
                                                        'due_at' => @mock_new_due_date,
                                                        'lock_at' => @mock_new_due_date,
                                                        'student_ids' => [@mock_student_uid.to_s],
                                                        'title' => "#{@mock_student_uid} extended to #{@mock_new_due_date}"
                                                      })
                },
                headers: { Authorization: "Bearer #{@auth_token}" }
              ).to_return(
                status: 200,
                body: { due_at: @mock_new_due_date, id: '3333' }.to_json,
                headers: {}
              )
            stub_request(:get, "#{@mock_assignments_url}/#{@assignment.external_assignment_id}")
              .to_return(
                status: 200,
                body: { due_at: '2024-04-13T16:00:00Z' }.to_json,
                headers: {}
              )

            request.headers[:Authorization] = @auth_token
            post :create, params: {
              course_id: @course.id,
              lms_id: @lms.id,
              assignment_id: @assignment.id,
              student_uid: @mock_student_uid,
              new_due_date: @mock_new_due_date
            }
            expect(response).to have_http_status(:success)
          end
        end

        context 'with missing parameters' do
          it 'raises an error' do
            stub_request(:post, @mock_override_url)
              .to_return(status: 400)

            stub_request(:get, "#{@mock_assignments_url}/#{@assignment.external_assignment_id}")
              .to_return(
                status: 200,
                body: { due_at: '2024-04-13T16:00:00Z' }.to_json,
                headers: {}
              )

            expect do
              post(:create, params: {
                     course_id: @course.id,
                     lms_id: @lms.id,
                     assignment_id: @assignment.id
                   })
            end.to raise_error(FailedPipelineError)
          end
        end

        context 'when canvas returns 500' do
          it 'returns a 500 status' do
            stub_request(:post, @mock_override_url)
              .to_return(
                status: 500,
                body: { errors: ['unknown student ids'] }.to_json
              )

            stub_request(:get, "#{@mock_assignments_url}/#{@assignment.external_assignment_id}")
              .to_return(
                status: 200,
                body: { due_at: '2024-04-13T16:00:00Z' }.to_json,
                headers: {}
              )

            post :create, params: {
              course_id: @course.id,
              lms_id: @lms.id,
              assignment_id: @assignment.id,
              student_uid: 9999,
              new_due_date: 7
            }
            expect(response).to have_http_status(500)
          end
        end

        context 'get assignment api call fails' do
          it "doesn't request a new extension and returns a server error" do
            stub_request(:post, @mock_override_url)
              .with(
                body: hash_including({
                                       due_at: @mock_new_due_date,
                                       lock_at: @mock_new_due_date,
                                       student_ids: [@mock_student_uid.to_s],
                                       title: "#{@mock_student_uid} extended to #{@mock_new_due_date}"
                                     }),
                headers: { Authorization: "Bearer #{@auth_token}" }
              )
              .to_return(
                status: 200,
                body: { due_at: @mock_new_due_date, id: '3333' }.to_json,
                headers: {}
              )

            stub_request(:get, "#{@mock_assignments_url}/#{@assignment.external_assignment_id}")
              .to_return(status: 404)

            request.headers[:Authorization] = @auth_token
            post :create, params: {
              course_id: @course.id,
              lms_id: @lms.id,
              assignment_id: @assignment.id,
              student_uid: @mock_student_uid,
              new_due_date: @mock_new_due_date
            }
            expect(response).to have_http_status(:error)
          end
        end
      end
    end
  end
end
