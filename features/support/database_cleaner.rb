require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :transaction

# For JS scenarios (you may not need this if you're not using @javascript)
Cucumber::Rails::Database.javascript_strategy = :truncation

Before do
  DatabaseCleaner.start
end

After do
  DatabaseCleaner.clean
end
