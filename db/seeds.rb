# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Assignment.destroy_all
Lms.destroy_all
Course.destroy_all
User.destroy_all

canvas = Lms.create!({
    lms_name: "Canvas",
    use_auth_token: true
})

p "Canvas ID: #{canvas.id}"


test_assignment = Assignment.create!({
  lms_id: canvas.id,
  name: "Test Assignment"
})

p "Test Assignment ID: #{test_assignment.id}"


test_course = Course.create!({
  course_name: "Test Course",
})

p "Test Course ID: #{test_course.id}"


test_user = User.create!({
  email: "testuser@gmail.com",
})

p "Test User ID: #{test_user.id}"