# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

# Configure SimpleCov before requiring other files
require 'simplecov'
require 'simplecov_json_formatter'
require 'dotenv'

# Load environment variables from .env file
Dotenv.load

# Only start SimpleCov if it hasn't been started
unless SimpleCov.running
  SimpleCov.start 'rails' do
    track_files 'app/**/*.rb'
    formatter SimpleCov::Formatter::MultiFormatter.new([
                                                         SimpleCov::Formatter::HTMLFormatter,
                                                         SimpleCov::Formatter::JSONFormatter
                                                       ])
  end
end

require 'cucumber/rails'
require 'rspec/mocks'
require 'rack_session_access/capybara'

World(RSpec::Mocks::ExampleMethods)

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     # { except: [:widgets] } may not do what you expect here
#     # as Cucumber::Rails::Database.javascript_strategy overrides
#     # this setting.
#     DatabaseCleaner.strategy = :truncation
#   end
#
#   Before('not @no-txn', 'not @selenium', 'not @culerity', 'not @celerity', 'not @javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
#

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :truncation

# Get Chrome and Chromedriver paths from environment variables
path_to_chromedriver = ENV.fetch('CHROMEDRIVER_PATH', nil)
path_to_chrome_for_testing = ENV.fetch('CHROME_FOR_TESTING_PATH', nil)

if path_to_chromedriver.blank? || path_to_chrome_for_testing.blank?
  if ENV['CI']
    # In CI, try to find the binaries in the system path
    path_to_chromedriver ||= `which chromedriver`.chomp
    path_to_chrome_for_testing ||= `which google-chrome`.chomp

    # Verify the binaries exist and are executable
    unless File.executable?(path_to_chromedriver) && File.executable?(path_to_chrome_for_testing)
      abort "Chrome/Chromedriver binaries not found or not executable in CI environment.\nChromedriver: #{path_to_chromedriver}\nChrome: #{path_to_chrome_for_testing}"
    end
  else
    # Local development fallbacks
    path_to_chromedriver ||= `which chromedriver`.chomp
    path_to_chrome_for_testing ||= '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
  end
end

abort "Cannot find Chromedriver binary at: #{path_to_chromedriver}" if path_to_chromedriver.blank?
abort "Cannot find Chrome binary at: #{path_to_chrome_for_testing}" if path_to_chrome_for_testing.blank?

Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  # Basic Chrome options
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1920,1080')

  # Additional stability options
  options.add_argument('--disable-site-isolation-trials')
  options.add_argument('--disable-web-security')
  options.add_argument('--disable-features=IsolateOrigins,site-per-process')

  # Performance options
  options.add_argument('--disable-dev-tools')
  options.add_argument('--dns-prefetch-disable')
  options.add_argument('--disable-browser-side-navigation')

  # Set Chrome binary path if provided
  options.binary = path_to_chrome_for_testing if path_to_chrome_for_testing.present?

  # Add headless mode if in CI
  if ENV['CI']
    options.add_argument('--headless=new')
    options.add_argument('--disable-extensions')
  end

  # Create driver with custom service if chromedriver path is provided
  service = path_to_chromedriver.blank? ? nil : Selenium::WebDriver::Service.chrome(path: path_to_chromedriver)

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    service: service,
    options: options,
    clear_local_storage: true,
    clear_session_storage: true
  )
end

# Register Chrome headless driver
Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  # Basic Chrome options
  options.add_argument('--headless=new')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1920,1080')

  # Additional stability options
  options.add_argument('--disable-site-isolation-trials')
  options.add_argument('--disable-web-security')
  options.add_argument('--disable-features=IsolateOrigins,site-per-process')

  # Performance options
  options.add_argument('--disable-dev-tools')
  options.add_argument('--dns-prefetch-disable')
  options.add_argument('--disable-browser-side-navigation')

  # Set Chrome binary path if provided
  options.binary = path_to_chrome_for_testing if path_to_chrome_for_testing.present?

  # Create driver with custom service if chromedriver path is provided
  service = path_to_chromedriver.blank? ? nil : Selenium::WebDriver::Service.chrome(path: path_to_chromedriver)

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    service: service,
    options: options,
    clear_local_storage: true,
    clear_session_storage: true
  )
end

# Use rack_test by default (faster)
Capybara.default_driver = :rack_test
# Use selenium_chrome_headless for JavaScript tests
Capybara.javascript_driver = :selenium_chrome_headless

# Increase timeouts for CI environment
if ENV['CI']
  Capybara.default_max_wait_time = 20
  Capybara.default_normalize_ws = true
else
  Capybara.default_max_wait_time = 10
end

# Set up hooks
Before do
  # Use rack_test by default
  Capybara.current_driver = :rack_test
end

Before('@javascript') do
  # Switch to selenium_chrome_headless for JavaScript tests
  Capybara.current_driver = :selenium_chrome_headless
end

After do
  # Always reset to default driver
  Capybara.use_default_driver
end

# Configure Capybara to use port 3000 for tests
# This is important for OAuth redirect_uri to work correctly
Capybara.server_port = 3000
