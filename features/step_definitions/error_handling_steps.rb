When(/^I try to authenticate with a missing code$/) do
  visit _path(error: 'access_denied')
end

When(/^I try to authenticate with an error response from Canvas$/) do
  visit canvas_callback_path(error: 'invalid_client')
end

Then(/^I should see an error message "(.*?)"$/) do |message|
  expect(page).to have_content(message)
end

Then(/^I should see an error message containing "(.*?)"$/) do |message|
  expect(page).to have_css('.alert', text: /#{message}/i)
end
