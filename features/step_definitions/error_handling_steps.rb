When(/^I try to authenticate with a missing code$/) do
  visit canvas_callback_path(error: "access_denied")
end

When(/^I try to authenticate with an error response from Canvas$/) do
  visit canvas_callback_path(error: "invalid_client")
end

Then(/^I should see an error message "(.*?)"$/) do |error_message|
  expect(page).to have_content(error_message)
end