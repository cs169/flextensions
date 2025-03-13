# features/support/axe_helper.rb

begin
  require 'axe-cucumber'
  require 'axe-cucumber-steps'
  require 'capybara-screenshot/cucumber'
  require 'selenium-webdriver'


rescue LoadError => e
  puts "Warning: Failed to load axe-core-cucumber: #{e.message}"
end
# Set up screenshot path
Capybara::Screenshot.autosave_on_failure = true
Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium_chrome
puts "Current driver: #{Capybara.current_driver}"

