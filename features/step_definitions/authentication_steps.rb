# TODO: Complete step def
When(/^I authorize bCourses with (in)?valid credentials$/) do |invalid|
  if invalid
    # Handle invalid login scenario
  else
    # Handle valid login scenario
  end
end

# TODO: Complete step
When(/^I am (not)? logged in as  user$/) do |logged_in|
  if logged_in
    # Handle logout scenario
  else
    # Handle login scenario
  end
end

# TODO: Complete step - Logout
When(/^I log out$/) do
  # Handle logout scenario
end


# TODO: Complete step
Then(/^I should see my username on the navbar$/) do
  # Handle username display scenario
end


# TODO: Complete step - navigate to any page other than X page
When(/^I navigate to any page other than "([^"]*)"$/) do |page_name|
  # Handle navigation scenario
end
