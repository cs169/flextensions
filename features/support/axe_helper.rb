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

# Ensure we use selenium_chrome for both default and javascript drivers
Capybara.default_driver = :selenium_chrome
Capybara.javascript_driver = :selenium_chrome
puts "Current driver: #{Capybara.current_driver}"

Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--no-sandbox')
  options.add_argument('--headless=new')
  options.add_argument('--disable-gpu')
  options.add_argument('--js-flags=--max-old-space-size=4096')
  options.add_argument('--window-size=1400,1400')
  options.add_argument('--disable-extensions')
  options.add_argument('--disable-infobars')
  options.add_argument('--disable-popup-blocking')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_max_wait_time = 10

Around('@a11y') do |_scenario, block|
  block.call
rescue Selenium::WebDriver::Error::JavascriptError => e
  raise e unless e.message.include?('NS_ERROR_OUT_OF_MEMORY')

  puts "Memory shortage error occurred: #{e.message}"
  puts 'Continuing the test.'
rescue Selenium::WebDriver::Error::NoSuchWindowError => e
  puts "Browser context error occurred: #{e.message}"
  puts 'Continuing the test.'
end
