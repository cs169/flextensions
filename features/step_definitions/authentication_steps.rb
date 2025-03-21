When(/^I authorize bCourses with (in)?valid credentials$/) do |invalid|
  if invalid
    # Set up a mock OAuth flow with invalid credentials
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:canvas] = :invalid_credentials
    visit '/auth/canvas'
  else
    # Set up a mock OAuth flow with valid credentials
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:canvas] = OmniAuth::AuthHash.new(
      {
        provider: 'canvas',
        uid: '12345',
        info: {
          name: 'Test User',
          email: 'test@example.com'
        },
        credentials: {
          token: 'mock_token',
          refresh_token: 'mock_refresh_token',
          expires_at: Time.now + 1.day.to_i
        }
      }
    )

    # Mock the Canvas API response for user data
    # Use RSpec's stub_any_instance_of instead of allow_any_instance_of
    if respond_to?(:stub_any_instance_of)
      api_response = double(success?: true, body: {
        id: '12345',
        name: 'Test User',
        email: 'test@example.com',
        primary_email: 'test@example.com'
      }.to_json)
      stub_any_instance_of(Faraday::Connection).to receive(:get)
        .with("#{ENV.fetch('CANVAS_URL', nil)}/api/v1/users/self?")
        .and_return(api_response)
    end

    @user_name = 'Test User'
    visit '/auth/canvas'
  end
end

Given(/^I am logged in as a user$/) do
  visit root_path

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
  sleep 1
  # puts "Current URL after clicking login: #{current_url}"

  # Take a screenshot to see what the page looks like
  # path = "#{Capybara.save_path}/canvas_login_page.png"
  # save_screenshot(path)
  # puts "Saved screenshot to #{path}"

  # Check if we're on an actual Canvas login page
  if current_url.include?('bcourses') || current_url.include?('instructure')
    # Check if we're on the authorization screen (user already logged in)
    if page.has_css?('input[value="Authorize"]') || page.has_button?('Authorize')
      puts 'Found Canvas authorization screen, clicking Authorize button'
      # Click the authorize button
      begin
        begin
          click_button('Authorize')
        rescue StandardError
          find('input[value="Authorize"]').click
        end
        puts 'Clicked Authorize button'
      rescue StandardError => e
        puts "Error clicking Authorize button: #{e.message}"
        raise e
      end
    else
      # We need to log in first
      puts 'On Canvas login page, attempting to log in'
      # Fill in credentials from environment variables
      if ENV['CANVAS_TEST_USERNAME'] && ENV['CANVAS_TEST_PASSWORD']
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
          puts "Attempted login with username: #{ENV['CANVAS_TEST_USERNAME']}"

          # Check for authorization screen after login
          sleep 1
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
  else
    puts "Warning: Not redirected to a Canvas login page. Current URL: #{current_url}"
    raise 'Not redirected to a Canvas login page'
  end

  # After login, set the username variable for other tests
  @user_name = ENV['CANVAS_TEST_USERNAME'] || 'Test User'
end

Given(/^I am not logged in as a user$/) do
  # Ensure the user is not logged in
  page.driver.submit :delete, logout_path, {}
  @user_name = nil
end

When(/^I log out$/) do
  click_link 'Logout'
end

Then(/^I should see my username on the navbar$/) do
  within('nav') do
    expect(page).to have_content(@user_name || 'Test User')
  end
end

When(/^I navigate to any page other than the "([^"]*)"$/) do |page_name|
  visit offerings_path unless page_name == 'Offerings page'
  visit root_path unless page_name == 'Home page'
end
