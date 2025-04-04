When(/^I click "(.*?)"$/) do |link_text|
  click_link link_text
end

Then(/^I should see "(.*?)" in the navbar$/) do |text|
  within('nav') do
    expect(page).to have_content(text)
  end
end

Then(/^I should not see "(.*?)" in the navbar$/) do |text|
  within('nav') do
    expect(page).not_to have_content(text)
  end
end

When(/^I navigate to any page other than the "(.*?)"$/) do |excluded_page|
  # Currently included home and courses page
  case excluded_page
  when 'Home page'
    visit courses_path
  when 'Courses page'
    visit root_path
  end
end

Given(/^the Canvas API is unavailable$/) do
  # Stub the API to simulate an unavailable API
  if respond_to?(:stub_any_instance_of)
    stub_any_instance_of(Faraday::Connection).to receive(:get)
      .and_raise(Faraday::ConnectionFailed.new('Connection failed'))
  else
    puts 'Warning: Could not stub Faraday::Connection. Test may not work as expected.'
  end
end

When(/^I directly access the "(.*?)"$/) do |page_name|
  case page_name
  when 'Offerings page'
    visit offerings_path
  when 'Home page'
    visit root_path
  when 'bCourses login page'
    visit bcourses_login_path
  else
    raise "Unknown page: #{page_name}"
  end
end
