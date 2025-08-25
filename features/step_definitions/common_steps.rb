# Common step definitions
Then(/^I should see an error message "(.*)"$/) do |error_message|
  expect(page).to have_css('.alert', text: /#{error_message}/i)
end

# Navigate to a page
When(/^I navigate to the "(.*?)"$/) do |page_name|
  case page_name
  when 'Home page'
    visit root_path
  when 'Courses page'
    visit courses_path
  # when 'bCourses login page'
  #   visit canvas_login_path
  else
    raise "Unknown page: #{page_name}"
  end
end

# Debugging step
Then(/^debug$/) do
  puts "Current URL: #{page.current_url}"
  # puts "Page content: #{page.text}"
  1 # force the context to this step.
  binding.irb
end

Then(/^debug JavaScript$/) do
  page.execute_script("console.log('Current URL: #{page.current_url}');")
  binding.irb
end
