# Click "Show" link for a request by assignment name
When(/^I click "Show" for the request for "([^"]*)"$/) do |assignment_name|
  request = Request.joins(:assignment).find_by(assignments: { name: assignment_name })
  raise "No request found for assignment #{assignment_name}" unless request

  visit course_request_path(@course, request)
end

# Set notes on the student's enrollment in the course
Given(/^the student for the course has notes "([^"]*)"$/) do |notes_text|
  student = User.joins(:user_to_courses).find_by(user_to_courses: { course: @course, role: 'student' })
  enrollment = UserToCourse.find_by(user: student, course: @course, role: 'student')
  enrollment.update!(notes: notes_text)
end
