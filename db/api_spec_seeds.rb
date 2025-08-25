##
# TODO: We should deprecate this file and refactor the tests.
# This is used only for extensions_controller_spec which should be deleted soon.

LmsCredential.destroy_all
Extension.destroy_all
Assignment.destroy_all
CourseToLms.destroy_all
UserToCourse.destroy_all
Course.destroy_all
User.destroy_all

# Assumes the actual db/seeds have been run.
canvas = Lms.find_by!(id: 1)

test_course = Course.create!({
  course_name: "Test Course",
})

test_course_to_lms = CourseToLms.create!({
  lms_id: canvas.id,
  course_id: test_course.id,
  external_course_id: "22222",
})

test_assignment = Assignment.create!({
  course_to_lms_id: test_course_to_lms.id,
  name: "Test Assignment",
  external_assignment_id: "11111",
})

test_user = User.create!({
  email: "testuser@example.com",
})

test_user_to_course = UserToCourse.create!({
  user_id: test_user.id,
  course_id: test_course.id,
  role: "test",
})

test_extension = Extension.create!({
  assignment_id: test_assignment.id,
  student_email: "teststudent@example.com",
  initial_due_date: DateTime.iso8601('2024-04-20'),
  new_due_date: DateTime.iso8601('2024-04-30'),
  last_processed_by_id: test_user.id,
  external_extension_id: "33333",
})

test_lms_credential = LmsCredential.create!({
  user_id: test_user.id,
  lms_name: "canvas",
  token: "test token",
  external_user_id: "44444",
})
