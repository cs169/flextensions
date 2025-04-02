# Common step definitions
Then(/^I should see an error message "(.*)"$/) do |error_message|
  expect(page).to have_css('.alert', text: /#{error_message}/i)
end

# Redirect check with explicit path verification
Then(/^I should be (on|redirected to) the "(.*?)"$/) do |_redirect_or_on, page_name|
  sleep 1
  expected_path =
    case page_name
    when 'Home page'
      root_path
    when 'Courses page'
      courses_path
    when 'bCourses login page'
      bcourses_login_path
    else
      raise "Unknown page: #{page_name}"
    end
  # screenshot
  # page.save_screenshot("screenshot_#{page_name}.png")
  # puts "Screenshot saved at path tmp/capybara/screenshot_#{page_name}.png"
  expect(page).to have_current_path(expected_path)
end

# Navigate to a page
When(/^I navigate to the "(.*?)"$/) do |page_name|
  case page_name
  when 'Home page'
    visit root_path
  when 'Courses page'
    visit courses_path
  when 'bCourses login page'
    visit bcourses_login_path
  else
    raise "Unknown page: #{page_name}"
  end
end
