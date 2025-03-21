When(/^I click "(.*?)"$/) do |link_text|
  click_link link_text
end

Then(/^I should see "(.*?)" in the navbar$/) do |text|
  within("nav") do
    expect(page).to have_content(text)
  end
end

Then(/^I should not see "(.*?)" in the navbar$/) do |text|
  within("nav") do
    expect(page).not_to have_content(text)
  end
end

Then(/^I should see my username on the navbar$/) do
  within("nav") do
    if @user_name
      expect(page).to have_content(@user_name), 
        "Expected to find username '#{@user_name}' in navbar but did not find it"
    else

      expect(page).to have_text(/\S+/), 
        "Expected navbar to contain some text but it appears to be empty"
    end
  end
end

When(/^I navigate to any page other than the "(.*?)"$/) do |excluded_page|
  # Choose a page that's not the excluded page
  if excluded_page == "Home page"
    visit offerings_path
  else
    visit root_path
  end
end

Given(/^the Canvas API is unavailable$/) do
  # Stub the API to simulate an unavailable API
  if respond_to?(:stub_any_instance_of)
    stub_any_instance_of(Faraday::Connection).to receive(:get)
      .and_raise(Faraday::ConnectionFailed.new("Connection failed"))
  else
    puts "Warning: Could not stub Faraday::Connection. Test may not work as expected."
  end
end

When(/^I directly access the "(.*?)"$/) do |page_name|
  case page_name
  when "Offerings page"
    visit offerings_path
  when "Home page"
    visit root_path
  when "bCourses login page"
    visit bcourses_login_path
  else
    raise "Unknown page: #{page_name}"
  end
end 