# Common step definitions
Then(/^I should see an error message "(.*)"$/) do |error_message|
  expect(page).to have_content(error_message)
  expect(page).to have_css('.alert', text: /#{error_message}/i)
end

# Redirect check
Then(/^I should be (on|redirected to) the "(.*?)"$/) do |redirect_or_on, page_name|
  case page_name
  when "Home page"
    expect(page).to have_current_path(root_path)
  when "Offerings page"
    expect(page).to have_current_path(offerings_path)
  when "bCourses login page"
    expect(page).to have_current_path(bcourses_login_path)
  else
    raise "Unknown page: #{page_name}"
  end
end

# Navigate to a page
When(/^I navigate to the "(.*?)"$/) do |page_name|
  case page_name
  when "Home page"
    visit root_path
  when "Offerings page"
    visit offerings_path
  when "bCourses login page"
    visit bcourses_login_path
  else
    raise "Unknown page: #{page_name}"
  end
end
