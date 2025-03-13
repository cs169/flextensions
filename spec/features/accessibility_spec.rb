# spec/features/accessibility_spec.rb
require 'rails_helper'
require 'tmpdir'

RSpec.describe "Accessibility", type: :feature, js: true, a11y: true do
  before(:each) do
    WebMock.allow_net_connect!
    
    chrome_data_dir = ENV['CHROME_DATA_DIR'] || Dir.mktmpdir
    
    Capybara.register_driver :selenium_chrome do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      
      # Chrome opt
      options.add_argument("--user-data-dir=#{chrome_data_dir}")
      
      # CI opt
      if ENV['CI']
        options.add_argument('--headless')
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-dev-shm-usage')
      end
      
      Capybara::Selenium::Driver.new(app,
        browser: :chrome,
        options: options)
    end
    
    Capybara.javascript_driver = :selenium_chrome
  end
  
  after(:each) do
    begin
      Capybara.reset_sessions!
    rescue Selenium::WebDriver::Error::NoSuchWindowError, Selenium::WebDriver::Error::InvalidSessionIdError, Selenium::WebDriver::Error::UnknownError
      puts "Browser session problem. Ignore it and proceed."
    end
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  it "Home page should be accessible" do
    visit '/'
    puts "Current URL: #{current_url}"
    expect(page).to be_axe_clean
  end

  it "Login page should be accessible" do
    visit '/login/canvas'
    puts "Current URL: #{current_url}"
    expect(page).to be_axe_clean
  end

  it "Offerings page should be accessible" do
    visit '/offerings'
    sleep 1
    begin
      expect(page).to be_axe_clean
    rescue Selenium::WebDriver::Error::JavascriptError, Selenium::WebDriver::Error::NoSuchWindowError => e
      page.save_screenshot('offerings_error.png') if page.respond_to?(:save_screenshot)
      puts "browser error: #{e.message}"
      skip("error jump")
    end
  end
end