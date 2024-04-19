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


test_assignment = Assignment.create!({
  lms_id: canvas.id,
  name: "Test Assignment"
})


test_course = Course.create!({
  course_name: "Test Course",
})

test_course_to_lms = CourseToLms.create!({
  lms_id: canvas.id,
  course_id: test_course.id
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
  last_processed_by_id: test_user.id
})

test_lms_credential = LmsCredential.create!({
  user_id: test_user.id,
  lms_name: "canvas",
  token: "test token"
})