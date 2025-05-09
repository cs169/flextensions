# features/support/database_cleaner.rb
require 'database_cleaner/active_record'

# Configure DatabaseCleaner for Cucumber
DatabaseCleaner.strategy = :truncation, { reset_ids: true }

# Run before each scenario
Before do
  DatabaseCleaner.start
end

# Run after each scenario
After do
  DatabaseCleaner.clean
end
