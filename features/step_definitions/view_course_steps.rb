require 'capybara/cucumber'

Given(/^I visit "([^"]*)"$/) do |path|
  visit path
end

Then(/^I should see a list of assignments$/) do
  expect(page).to have_css('table#assignments-table')
end

Then(/^I should see a button with class "nav-link active" containing "([^"]*)"$/) do |button_text|
  expect(page).to have_css('button.nav-link.active', text: button_text)
end

Then(/^I should see a checkbox input with id "([^"]*)"$/) do |element_id|
  expect(page).to have_css("input##{element_id}[type='checkbox']")
end