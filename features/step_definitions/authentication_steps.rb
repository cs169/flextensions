Given(/^I am logged in as a user$/) do
  visit login_path
  sleep 1
  # Check if already logged in by checking for the username on page
  if page.has_css?('.testid-username')
    puts 'Already logged in, continuing'
  else
    # Login
    login_with_credentials(ENV.fetch('CANVAS_TEST_USERNAME', nil), ENV.fetch('CANVAS_TEST_PASSWORD', nil))
    click_authorize_button
    puts "After login, current path: #{current_path}"

    # page.save_screenshot('username-courses_page.png')
    expect(page).to have_css('.testid-username')
  end
end

Given(/^I am not logged in as a user$/) do
  visit courses_path
  sleep 1
  expect(page).not_to have_css('.testid-username')
end

When(/^I log out$/) do
  if page.has_css?('.testid-logout-button')
    find('.testid-logout-button').click
  else
    puts 'Warning: Logout button with testid-logout-button class not found'
  end
end

Then(/^I should see my name on the navbar$/) do
  within('.testid-username') do
    expect(page).to have_content(ENV.fetch('CANVAS_TEST_NAME', nil))
  end
end

When(/^I authorize bCourses with (in)?valid credentials$/) do |invalid|
  if invalid
    login_with_credentials('invalid_user', 'invalid_password')
  else
    login_with_credentials(ENV.fetch('CANVAS_TEST_USERNAME', nil), ENV.fetch('CANVAS_TEST_PASSWORD', nil))

    click_authorize_button
  end
end

def click_authorize_button
  sleep 1
  return unless page.has_css?('input[value="Authorize"]') || page.has_button?('Authorize')

  puts 'Found authorization screen after login, clicking Authorize button'
  begin
    click_button('Authorize')
  rescue StandardError
    find('input[value="Authorize"]').click
  end
end

def login_with_credentials(username, password)
  if page.has_selector?('#pseudonym_session_unique_id')
    fill_in 'pseudonym_session[unique_id]', with: username
    fill_in 'pseudonym_session[password]', with: password
    begin
      click_button 'Log In'
    rescue StandardError
      find('button[type="submit"]').click
    end
    # page.save_screenshot('login_page.png')
    puts "Current path after login attempt: #{current_path}"
    sleep 1
  else
    puts 'Error: No login form found'
  end
end

def click_login_button
  if page.has_css?('.testid-loginbutton')
    find('.testid-loginbutton').click
  else
    puts 'Warning: Login button with testid-loginbutton class not found'
  end
end
