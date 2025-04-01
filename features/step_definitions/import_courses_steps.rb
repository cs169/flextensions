Given('a user exists with canvas_uid {string} and canvas_token {string}') do |canvas_uid, canvas_token|
  @user = User.create!(canvas_uid: canvas_uid, canvas_token: canvas_token)
end

Given('the following courses are available from Canvas:') do |table|
  @courses = table.hashes
  allow_any_instance_of(CoursesController).to receive(:fetch_courses).and_return(@courses)
end

Given('I am logged in as the user with canvas_uid {string}') do |canvas_uid|
  user = User.find_by(canvas_uid: canvas_uid)
  page.set_rack_session(user_id: user.canvas_uid)
end

When('I visit the new courses page') do
  visit new_course_path
end

When('I select the course {string}') do |course_name|
  course = @courses.find { |c| c['name'] == course_name }
  check("course_#{course['id']}")
end

When('I click {string}') do |button_text|
  click_button button_text
end

Then('I should see {string}') do |message|
  expect(page).to have_content(message)
end

Then('I should see {string} in the teacher courses list') do |course_name|
  within('#teacher-courses') do
    expect(page).to have_content(course_name)
  end
end

Then('I should see {string} in the student courses list') do |course_name|
  within('#student-courses') do
    expect(page).to have_content(course_name)
  end
end

Then('the teacher courses list should not have duplicates') do
  within('#teacher-courses') do
    course_names = all('label').map(&:text)
    expect(course_names.uniq).to eq(course_names)
  end
end

Then('the student courses list should not have duplicates') do
  within('#student-courses') do
    course_names = all('label').map(&:text)
    expect(course_names.uniq).to eq(course_names)
  end
end

Then('the user should be associated with the course {string}') do |course_name|
  course = Course.find_by(course_name: course_name)
  expect(@user.courses).to include(course)
end

Then('the user should not be associated with the course {string}') do |course_name|
  course = Course.find_by(course_name: course_name)
  expect(@user.courses).not_to include(course)
end

Then('I should be redirected to the login page') do
  expect(current_path).to eq(root_path)
end

Then('the user should not be associated with any courses') do
  expect(@user.courses).to be_empty
end