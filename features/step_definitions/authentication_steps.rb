Given(/^I am not logged in as a user$/) do
  # Ensure the user is not logged in
  page.driver.submit :delete, logout_path, {}
  @user_name = nil
end

When(/^I log out$/) do
  click_link 'Logout'
end

Then(/^I should see my username on the navbar$/) do
  within('[data-testid="user-name"]') do
    expect(page).to have_content(@user_name || 'Test User')
  end
end

When(/^I navigate to any page other than the "([^"]*)"$/) do |page_name|
  visit offerings_path unless page_name == 'Offerings page'
  visit root_path unless page_name == 'Home page'
end

When(/^I authorize bCourses with (in)?valid credentials$/) do |invalid|
  if invalid
    # Invalid credentials
    if page.has_selector?('#pseudonym_session_unique_id')
      # Canvas direct login
      fill_in 'pseudonym_session[unique_id]', with: 'invalid_user'
      fill_in 'pseudonym_session[password]', with: 'invalid_password'
      begin
        click_button 'Log In'
      rescue StandardError
        find('button[type="submit"]').click
      end
    elsif page.has_selector?('#username')
      # Berkeley CAS login
      fill_in 'username', with: 'invalid_user'
      fill_in 'password', with: 'invalid_password'
      begin
        begin
          click_button 'Sign In'
        rescue StandardError
          click_button 'Login'
        end
      rescue StandardError
        find('button[type="submit"]').click
      end
    else
      # Generic form
      within('form') do
        inputs = all('input[type="text"], input[type="email"], input:not([type="hidden"])')
        password_inputs = all('input[type="password"]')

        inputs.first.fill_in with: 'invalid_user' if inputs.any?
        password_inputs.first.fill_in with: 'invalid_password' if password_inputs.any?

        find('button[type="submit"], input[type="submit"]').click
      end
    end
  else
    # Valid credentials from environment variables
    if page.has_selector?('#pseudonym_session_unique_id')
      # Canvas direct login
      fill_in 'pseudonym_session[unique_id]', with: ENV.fetch('CANVAS_TEST_USERNAME', nil)
      fill_in 'pseudonym_session[password]', with: ENV.fetch('CANVAS_TEST_PASSWORD', nil)
      begin
        click_button 'Log In'
      rescue StandardError
        find('button[type="submit"]').click
      end
    elsif page.has_selector?('#username')
      # Berkeley CAS login
      fill_in 'username', with: ENV.fetch('CANVAS_TEST_USERNAME', nil)
      fill_in 'password', with: ENV.fetch('CANVAS_TEST_PASSWORD', nil)
      begin
        begin
          click_button 'Sign In'
        rescue StandardError
          click_button 'Login'
        end
      rescue StandardError
        find('button[type="submit"]').click
      end
    else
      # Generic form
      within('form') do
        inputs = all('input[type="text"], input[type="email"], input:not([type="hidden"])')
        password_inputs = all('input[type="password"]')

        inputs.first.fill_in with: ENV.fetch('CANVAS_TEST_USERNAME', nil) if inputs.any?
        password_inputs.first.fill_in with: ENV.fetch('CANVAS_TEST_PASSWORD', nil) if password_inputs.any?

        find('button[type="submit"], input[type="submit"]').click
      end
    end

    # Check for authorization screen after login
    sleep 2
    if page.has_css?('input[value="Authorize"]') || page.has_button?('Authorize')
      puts 'Found authorization screen after login, clicking Authorize button'
      begin
        click_button('Authorize')
      rescue StandardError
        find('input[value="Authorize"]').click
      end
      puts 'Clicked Authorize button after login'
    end
  end
end

def click_login_button
  # Click on the login button from the home page
  # First try the button in the specific container on the home page
  if page.has_css?('.col-12.text-center a.btn')
    find('.col-12.text-center a.btn', text: 'Login').click
  else
    # If that's not available, try finding by specific class or fallback to first matching link
    begin
      find('a.btn.btn-secondary', text: 'Login').click
    rescue StandardError
      first('a', text: 'Login').click
    end
  end

  # This should redirect to the Canvas login page
  sleep 2
  puts "Current URL after clicking login: #{current_url}"
end

def log_in_canvas
  # Check if we're on an actual Canvas login page
  if current_url.include?('bcourses') || current_url.include?('instructure')
    puts "Successfully reached Canvas login page: #{current_url}"
    # Check if we're on the authorization screen (user already logged in)
    if page.has_css?('input[value="Authorize"]') || page.has_button?('Authorize')
      # Click the authorize button
      begin
        begin
          click_button('Authorize')
        rescue StandardError
          find('input[value="Authorize"]').click
        end
      rescue StandardError => e
        puts "Error clicking Authorize button: #{e.message}"
        raise e
      end
    elsif ENV['CANVAS_TEST_USERNAME'] && ENV['CANVAS_TEST_PASSWORD']
      # We need to log in first
      # Fill in credentials from environment variables
      begin
        if page.has_selector?('#pseudonym_session_unique_id')
          # Canvas direct login
          fill_in 'pseudonym_session[unique_id]', with: ENV.fetch('CANVAS_TEST_USERNAME', nil)
          fill_in 'pseudonym_session[password]', with: ENV.fetch('CANVAS_TEST_PASSWORD', nil)
          begin
            begin
              click_button 'Log In'
            rescue StandardError
              find('input[type="submit"][value="Log In"]').click
            end
          rescue StandardError
            find('button[type="submit"]').click
          end
        elsif page.has_selector?('#username')
          # Berkeley CAS login
          fill_in 'username', with: ENV.fetch('CANVAS_TEST_USERNAME', nil)
          fill_in 'password', with: ENV.fetch('CANVAS_TEST_PASSWORD', nil)
          begin
            begin
              click_button 'Sign In'
            rescue StandardError
              click_button 'Login'
            end
          rescue StandardError
            find('button[type="submit"]').click
          end
        else
          within('form') do
            # Find input fields
            inputs = all('input[type="text"], input[type="email"], input:not([type="hidden"])')
            password_inputs = all('input[type="password"]')

            # Fill in the first visible text input with username and then password
            inputs.first.fill_in with: ENV.fetch('CANVAS_TEST_USERNAME', nil) if inputs.any?
            password_inputs.first.fill_in with: ENV.fetch('CANVAS_TEST_PASSWORD', nil) if password_inputs.any?

            # Click the submit button
            find('button[type="submit"], input[type="submit"]').click
          end
        end

        # Check for authorization screen after login
        sleep 2
        if page.has_css?('input[value="Authorize"]') || page.has_button?('Authorize')
          puts 'Found authorization screen after login, clicking Authorize button'
          begin
            click_button('Authorize')
          rescue StandardError
            find('input[value="Authorize"]').click
          end
          puts 'Clicked Authorize button after login'
        end
      rescue StandardError => e
        puts "Error during login attempt: #{e.message}"
        raise e
      end
    else
      puts 'Warning: CANVAS_TEST_USERNAME and CANVAS_TEST_PASSWORD must be set in .env file'
      raise 'CANVAS_TEST_USERNAME and CANVAS_TEST_PASSWORD must be set in .env file'
    end
  end
  sleep 1
  # Screenshot and logging
  page.save_screenshot('after_login.png')
  puts "After login, current URL: #{current_url}"
end

def login_setup_session
end

Given(/^I am logged in as a user$/) do
  if @logged_in
    puts 'Already logged in, skipping login steps'
    return
  end

  visit root_path
  click_login_button
  log_in_canvas

  # Go to courses and verify
  visit courses_path
  sleep 1
  puts "After login, current path: #{current_path}"

  # Store session state
  @logged_in = true
  @user_id = '213'
  @current_path = '/courses'
  @user_name = 'Test User'
end
