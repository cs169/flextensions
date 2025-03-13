# spec/support/accessibility_helper.rb
require 'axe-rspec'

module AccessibilityHelper
  # Configure axe-core-rspec
  def configure_axe_core
    page.driver.browser.manage.window.resize_to(1400, 1400) if page.driver.browser.respond_to?(:manage)
    
    Axe::Rspec.configure do |config|
      config.skip_iframes = true
      config.rules.delete('color-contrast') # Skip color contrast checks if needed
    end
  end
end

RSpec.configure do |config|
  config.before(:each, type: :feature, a11y: true) do
    page.driver.browser.manage.window.resize_to(1400, 1400) if page.driver.browser.respond_to?(:manage)
  end
end