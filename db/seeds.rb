# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

LmsCredential.destroy_all
Extension.destroy_all
Assignment.destroy_all
CourseToLms.destroy_all
UserToCourse.destroy_all
Course.destroy_all
Lms.destroy_all
User.destroy_all

canvas = Lms.create!({
    lms_name: "Canvas",
    use_auth_token: true
})


test_course = Course.create!({
  course_name: "Test Course",
})

test_course_to_lms = CourseToLms.create!({
  lms_id: canvas.id,
  course_id: test_course.id,
  external_course_id: "22222"
})

test_assignment = Assignment.create!({
  course_to_lms_id: test_course_to_lms.id,
  name: "Test Assignment",
  external_assignment_id: "11111"
})

test_user = User.create!({
  email: "testuser@example.com",
})

test_user_to_course = UserToCourse.create!({
  user_id: test_user.id,
  course_id: test_course.id,
  role: "test"
})

test_extension = Extension.create!({
  assignment_id: test_assignment.id,
  student_email: "teststudent@example.com",
  initial_due_date: DateTime.iso8601('2024-04-20'),
  new_due_date: DateTime.iso8601('2024-04-30'),
  last_processed_by_id: test_user.id,
  external_extension_id: "33333"
})

test_lms_credential = LmsCredential.create!({
  user_id: test_user.id,
  lms_name: "canvas",
  token: "test token",
  external_user_id: "44444"
})

real_course = Course.create!({
  course_name: "CS169L Flextension",
})

real_course_to_lms = CourseToLms.create!({
  lms_id: canvas.id,
  course_id: real_course.id,
  external_course_id: "1534405"
})

real_assignment = Assignment.create!({
  course_to_lms_id: real_course_to_lms.id,
  name: "Seed Data Testing",
  external_assignment_id: "8741483"
})

real_extension = Extension.create!({
  assignment_id: real_assignment.id,
  student_email: "teststudent@example.com",
  initial_due_date: DateTime.iso8601('2024-04-20'),
  new_due_date: DateTime.iso8601('2024-04-27'),
  last_processed_by_id: test_user.id,
  external_extension_id: "270163"
})