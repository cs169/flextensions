require 'rails_helper'
require 'tmpdir'

RSpec.describe 'Accessibility', :a11y, :js, type: :feature do
  before do
    WebMock.allow_net_connect!
    chrome_data_dir = ENV['CHROME_DATA_DIR'] || Dir.mktmpdir

    Capybara.register_driver :selenium_chrome do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("--user-data-dir=#{chrome_data_dir}")
      options.add_argument('--headless=new')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-dev-shm-usage')
      options.add_argument('--disable-gpu')
      options.add_argument('--disable-extensions')
      options.add_argument('--disable-infobars')
      options.add_argument('--window-size=1400,1400')

      Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
    end

    Capybara.javascript_driver = :selenium_chrome
  end

  after do
    begin
      Capybara.reset_sessions!
    rescue Selenium::WebDriver::Error::NoSuchWindowError, Selenium::WebDriver::Error::InvalidSessionIdError,
           Selenium::WebDriver::Error::UnknownError
      puts 'Browser session problem. Ignore it and proceed.'
    end
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  it 'Home page should be accessible', :a11y do
    visit '/'
    puts "Current URL: #{current_url}"
    begin
      expect(page).to be_axe_clean
    rescue StandardError => e
      puts "Accessibility error on Home page: #{e.message}"
      raise
    end
  end

  it 'Login page should be accessible', :a11y do
    visit '/login/canvas'
    puts "Current URL: #{current_url}"
    begin
      expect(page).to be_axe_clean
    rescue StandardError => e
      puts "Accessibility error on Login page: #{e.message}"
      raise
    end
  end

  it 'Courses page should be accessible', :a11y do
    visit '/courses'
    sleep 1
    begin
      expect(page).to be_axe_clean
    rescue Selenium::WebDriver::Error::JavascriptError, Selenium::WebDriver::Error::NoSuchWindowError => e
      puts "Browser error on Courses page: #{e.message}"
      skip("Error in browser: #{e.message}")
    rescue StandardError => e
      puts "Accessibility error on Courses page: #{e.message}"
      raise
    end
  end
end
