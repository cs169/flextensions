Given(/^a course exists$/) do
  FactoryBot.rewind_sequences
  @course = create(:course, course_name: 'Physics 110A', canvas_id: 'Phys110A', course_code: 'PHYS110A')

  teacher = create(:teacher, email: 'user1@berkeley.edu', canvas_uid: 'canvas_uid_1')
  create(:user_to_course, user: teacher, course: @course, role: 'teacher')

  ta = create(:ta, email: 'user2@berkeley.edu', canvas_uid: 'canvas_uid_2')
  create(:user_to_course, user: ta, course: @course, role: 'ta')

  3.times do |i|
    student = create(:student, email: "user#{i + 3}@berkeley.edu", canvas_uid: "canvas_uid_#{i + 3}")
    create(:user_to_course, user: student, course: @course, role: 'student')
  end
end

Given(/^I am logged in as an admin$/) do
  user = create(:admin, email: 'admin@berkeley.edu', canvas_uid: 'canvas_uid_admin')
  page.set_rack_session(user_id: user.canvas_uid, username: user.name)
end

Given(/^(?:I am|I'm|I) (?:logged|log) in as a (teacher|ta|student)$/i) do |role|
  emails = {
    'teacher' => 'user1@berkeley.edu',
    'ta' => 'user2@berkeley.edu',
    'student' => 'user3@berkeley.edu'
  }
  email = emails[role.downcase]
  user = User.find_by(email: email) || create(role.to_sym, email: email)
  page.set_rack_session(user_id: user.canvas_uid, username: user.name)
end

# clicking on buttons in a table row
# And I click New for "Homework 1"
# And I click Approve for "Homework 2"
When(/^I click ([^"]*) for "(.*?)"(?: in the "(.*)")?$/) do |button_text, row_text, table_id|
  table_selector = "##{table_id}"
  within(table_selector) do
    within(:xpath, ".//tr[td[contains(normalize-space(.), '#{row_text}')]]") do
      click_on button_text
    end
  end
end

# Redirection step that uses paths from paths.rb
# Then I should be on the "Courses page"
# Then I should be on the "request extension page" with param assignment_id=1
# Then I should be redirected to the "user profile page" with param name=yaman
Then(/^I should be (on|redirected to) the "(.*?)"(?: with param (\w+)=(.+))?$/) do |_redirect_or_on, page_name, param_key, param_value|
  # sleep 2 # Wait for redirection if needed
  expected_path = path_to(page_name)

  current_url = page.current_url
  url = URI.parse(current_url)

  # Check that path matches expected
  expect(url.path).to eq(expected_path)

  # If a key=value param is given, check it's present in query params
  if param_key && param_value
    query_params = Rack::Utils.parse_query(url.query)

    expect(query_params).to include(param_key => param_value)
  end
end

# TODO: Consider allowing the model to be an option instead of just an assignment
# Use phrase "the page" to avoid an ambiguous regex match with the above step.
# We should consolidate these two or use more different phrases
Then(/^I should be (?:on|redirected to) the page "(.*?)" for assignment "(.*?)"$/) do |page_name, assignment_name|
  # sleep 2 # Wait for redirection if needed
  expected_path = path_to(page_name)

  current_url = page.current_url
  url = URI.parse(current_url)

  # Check that path matches expected
  expect(url.path).to eq(expected_path)

  assignment = Assignment.find_by(name: assignment_name)
  expect(assignment).to be_present
  query_params = Rack::Utils.parse_query(url.query)
  expect(query_params).to include('assignment_id' => assignment.id.to_s)
end

# Checks a select input has a selected option
# Then the "Assignment" select should have "Homework 2" selected
Then(/^the "([^"]*)" select should have "([^"]*)" selected$/) do |field, expected_option|
  select_element = find_field(field)
  selected_option = select_element.value

  # Find the text of the selected option by matching the value
  option_text = select_element.find("option[value='#{selected_option}']").text

  expect(option_text).to eq(expected_option)
end

# Checks date on page with formatting and calculated days from now as in factories
# Then I should see "Original Due Date" formatted as 7 days from now
# Then I should see "Original Late Due Date" formatted as 10 days from now
Then(/^I should see "(.*?)" formatted as (\d+) days from now$/) do |label, days_from_now|
  expected_date = (Time.zone.now + days_from_now.to_i.days).strftime('%a, %b %-d, %Y at %-I:%M%P').strip
  normalized_expected = expected_date.gsub(/\s+/, ' ').tr("\u00A0", ' ') # Replace multiple spaces and &nbsp; by single space

  page_text = page.text.gsub(/\s+/, ' ').tr("\u00A0", ' ')
  expect(page_text).to include("#{label}: #{normalized_expected}")
end

# Filling an input with date formatted correctly and calculated days from now as in factories
# And I fill in Requested Due Date with date formatted as 5 days from now
When(/^I fill in (.+) with date formatted as (\d+) days from now$/i) do |field_label, days|
  date = (Time.zone.now + days.to_i.days).strftime('%m-%d-%Y')

  # Use Capybara's fill_in with label or name
  fill_in(field_label, with: date)
end

###################
#      STUBS      #
###################

# Stubbing flash for when you can't use the controller
Given(/^I set flash message "(.*)"$/) do |message|
  page.set_rack_session('flash' => { 'notice' => message })
end

# Toggle "Approved Extended?" checkbox for a student by name
# And I toggle "Approved Extended?" for "User 3"
When(/^I toggle "Approved Extended\?" for "([^"]*)"$/) do |user_name|
  within(:xpath, "//tr[td[contains(., '#{user_name}')]]") do
    find('input[type="checkbox"]').click
  end
  # Wait for the PATCH request to complete
  sleep 1
end

# Check that the enrollment's allow_extended_requests is enabled/disabled
# Then the enrollment for "User 3" should allow/disallow extended requests
Then(/^the enrollment for "([^"]*)" should (allow|disallow) extended requests$/) do |user_name, state|
  user = User.find_by!(name: user_name)
  enrollment = UserToCourse.find_by!(user: user, course: @course, role: 'student')
  expected = (state == 'allow')
  expect(enrollment.reload.allow_extended_requests).to eq(expected)
end

# Set up an enrollment with allow_extended_requests enabled
# Given the enrollment for "User 3" allows extended requests
Given(/^the enrollment for "([^"]*)" allows extended requests$/) do |user_name|
  user = User.find_by!(name: user_name)
  enrollment = UserToCourse.find_by!(user: user, course: @course, role: 'student')
  enrollment.update!(allow_extended_requests: true)
end

# this step is necessary to workaround ajax call to enable assignments
# And I enable "Homework 1"
Given(/^I (enable|disable) "([^"]*)"$/) do |action, assignment_name|
  enabled = (action == 'enable')
  assignment = Assignment.find_by(name: assignment_name)

  raise "Assignment with name '#{assignment_name}' not found" unless assignment

  assignment.update!(enabled: enabled)
end

# Stubbing the Approve controller
# Given I approve the request for "Homework 2"
Given(/^I approve the request for "([^"]*)"$/) do |assignment_name|
  request = Request.joins(:assignment)
                   .find_by(assignments: { name: assignment_name }, status: 'pending')

  raise "No pending request found for assignment #{assignment_name}" unless request

  # Directly update request status to approved
  request.update!(status: 'approved', auto_approved: false)

  # Flash message simulation:
  page.set_rack_session('flash' => { 'notice' => 'Request approved and extension created successfully in Canvas.' })
  visit current_path # reload page to reflect changes
end

# Stubbing the Deny controller
# Given I deny the request for "Homework 3"
# Create a request for a specific student using factory data
Given(/^a request exists for student "([^"]*)"$/) do |student_name|
  student = User.find_by(name: student_name)
  assignment = Assignment.first
  create(:request, user: student, course: @course, assignment: assignment)
end

# Click a specific student's name link on the enrollments page
When(/^I click the name link for student "([^"]*)"$/) do |student_name|
  within('#enrollments-table') do
    click_link student_name
  end
end

# Verify the DataTable search input has a value (i.e., filter is active)
Then(/^the requests table search should be filtered$/) do
  search_input = find('.dt-search input')
  expect(search_input.value).not_to be_empty
end

Given(/^a pending request exists$/) do
  student = User.joins(:user_to_courses).find_by(user_to_courses: { course: @course, role: 'student' })
  assignment = Assignment.first
  @pending_request = create(:request, user: student, course: @course, assignment: assignment)
end

Then(/^the "([^"]*)" button should appear after the requests table$/) do |button_text|
  table = find('#requests-table')
  button = find('button', text: button_text)
  expect(table.native.xpath("following::button[normalize-space(.)='#{button_text}']").any?).to be true
end

When(/^I click the status cell for that request$/) do
  within(:xpath, "//tr[td[contains(@data-export, '')]][1]") do
    find('td:last-child a').click
  end
end

Then(/^I should be on the request page for that request$/) do
  expected_path = "/courses/#{@course.id}/requests/#{@pending_request.id}"
  expect(page.current_path).to eq(expected_path)
end

###################
#    SYNC UI      #
###################

# Then I should see a "Sync Enrollments" button
Then(/^I should see a "([^"]*)" button$/) do |label|
  expect(page).to have_button(label)
end

# When I click the "Sync Enrollments" button
When(/^I click the "([^"]*)" button$/) do |label|
  # csrf_meta_tags renders nothing when allow_forgery_protection = false (test env).
  # Inject a placeholder token so JS fetch handlers don't throw before disabling the button.
  page.execute_script(<<~JS)
    if (!document.querySelector('meta[name="csrf-token"]')) {
      const m = document.createElement('meta');
      m.name = 'csrf-token';
      m.content = 'test-csrf-token';
      document.head.appendChild(m);
    }
  JS
  click_button(label)
end

# Then the "Sync Enrollments" button should be disabled
# When sync starts, the label changes to "Syncing..." so we check for that text + disabled
Then(/^the "([^"]*)" button should be disabled$/) do |_label|
  expect(page).to have_button("Syncing...", disabled: true)
end

# Then I should see a loading spinner
Then(/^I should see a loading spinner$/) do
  expect(page).to have_css('.spinner-border:not(.d-none)', visible: true)
end

Given(/^I deny the request for "([^"]*)"$/) do |assignment_name|
  request = Request.joins(:assignment)
                   .find_by(assignments: { name: assignment_name }, status: 'pending')

  raise "No pending request found for assignment #{assignment_name}" unless request

  # Directly update request status to denied
  request.update!(status: 'denied')

  # Flash message simulation:
  page.set_rack_session('flash' => { 'notice' => 'Request denied successfully.' })
  visit current_path # reload page to reflect changes
end
