# Load the Rails application.
require_relative "application"

ENV['CANVAS_URL'] ||= 'https://ucberkeley.test.instructure.com'

# Initialize the Rails application.
Rails.application.initialize!
