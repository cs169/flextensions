Given(/^I am logged in as a user with "(.*?)" role$/) do |role|
  # Store the role for later use
  @role = role
  @user_name = ENV['CANVAS_TEST_USERNAME'] || "Test #{role.capitalize} User"
  
  # Use the same login steps as regular login
  steps %{
    Given I am logged in as a user
  }
end

Given(/^I am logged in as a user with no courses$/) do
  @user_name = ENV['CANVAS_TEST_USERNAME'] || "Test User With No Courses"
  
  # Use the same login steps as regular login
  steps %{
    Given I am logged in as a user
  }
  
  # After login, manually handle the courses display
  begin
    # If we're in test mode and can use test doubles, stub the course fetching
    if respond_to?(:stub_any_instance_of)
      stub_any_instance_of(OfferingsController).to receive(:fetch_courses).and_return([])
    end
  rescue StandardError => e
    puts "Warning: Could not stub courses: #{e.message}"
  end
end

Given(/^I am logged in as a user with an invalid token$/) do
  @user_name = ENV['CANVAS_TEST_USERNAME'] || "Test User With Invalid Token"
  
  # Use the same login steps as regular login
  steps %{
    Given I am logged in as a user
  }
  
  # After login, manually simulate token failure
  begin
    if respond_to?(:stub_any_instance_of)
      stub_any_instance_of(OfferingsController).to receive(:fetch_courses).and_return([])
      # This will cause an error message to be displayed
      stub_any_instance_of(OfferingsController).to receive(:new).and_raise("Failed to fetch courses from Canvas")
    end
  rescue StandardError => e
    puts "Warning: Could not stub token failure: #{e.message}"
  end
end

Then(/^I should see my courses where I am a (teacher|student)$/) do |role|
  if role == "teacher"
    expect(page).to have_css(".teacher-courses")
    expect(page).to have_content("Courses where you are a teacher")
  else
    expect(page).to have_css(".student-courses")
    expect(page).to have_content("Courses where you are a student")
  end
end

Then(/^I should not see courses where I am not enrolled$/) do
  expect(page).not_to have_content("Course you are not enrolled in")
end

Then(/^I should see a message "(.*?)"$/) do |message|
  expect(page).to have_content(message)
end