# config/environments/staging.rb

# Load the production environment settings as a base
# and override specific settings for staging.
require_relative './production'

Rails.application.configure do
  # Staging-specific overrides
  config.log_level = :debug
  # Show full error reports, OK because staging is behind a VPN
  config.consider_all_requests_local = true

  # TODO: Configure ActionMailer to re-write emails to send to staging addresses
  # config.action_mailer.perform_deliveries = false
end
