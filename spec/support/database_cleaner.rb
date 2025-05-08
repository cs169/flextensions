# spec/support/database_cleaner.rb
require 'database_cleaner/active_record'

RSpec.configure do |config|
  # Before the whole suite runs, clean with truncation and reset IDs.
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, reset_ids: true) # Clean and reset sequences once before suite starts
    DatabaseCleaner.strategy = :truncation # Set strategy here; options given during clean_with
  end

  # Start cleaning before each example
  config.before do
    DatabaseCleaner.start
  end

  # Clean (truncate + reset) after each example
  config.after do
    DatabaseCleaner.clean
  end
end
