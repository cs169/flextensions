# TODO: Complete step def
When(/^I authorize bCourses with (in)?valid credentials$/) do |invalid|
  if invalid
    # Handle invalid login scenario
  else
    # Handle valid login scenario
  end
end

# Login status steps
Given(/^I am logged in as a user$/) do
  # TODO: Set up a logged-in user session
  # Example:
  # user = User.create!(email: 'test@example.com', password: 'password')
  # visit login_path
  # fill_in 'Email', with: user.email
  # fill_in 'Password', with: 'password'
  # click_button 'Log in'
end

Given(/^I am not logged in as a user$/) do
  # TODO: Ensure the user is not logged in
  # Example:
  # visit logout_path if page.has_link?('Logout')
  # or
  # reset_session!
end

# TODO: Complete step - Logout
When(/^I log out$/) do
  # Handle logout scenario
  # Example:
  # click_link 'Logout'
end

# TODO: Complete step
Then(/^I should see my username on the navbar$/) do
  # Handle username display scenario
  # Example:
  # expect(page).to have_css('.navbar .username', text: 'test@example.com')
end

# Navigate to any page other than a specific one
When(/^I navigate to any page other than the "([^"]*)"$/) do |page_name|
  # Handle navigation scenario
  # Example:
  # visit courses_path unless page_name == "Courses page"
end
