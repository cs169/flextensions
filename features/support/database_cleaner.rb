# features/support/database_cleaner.rb
require 'database_cleaner/active_record'

# Load seeds once before all scenarios
BeforeAll do
  Rails.application.load_seed
  puts "Loaded seeds"
end

##
# TODO: It would be nice to replace DatabaseCleaner with transactional fixtures
# or a simple mechanism which mimics them in Cucumber scenarios.
# # Start transaction before each scenario (like use_transactional_fixtures)
# Before do
#   ActiveRecord::Base.connection.begin_transaction(joinable: false)
# end

# # Rollback transaction after each scenario
# After do
#   ActiveRecord::Base.connection.rollback_transaction
# end

# # Run before each scenario
Before do
  DatabaseCleaner.strategy = :transaction
  DatabaseCleaner.start
end

# Run after each scenario
After do
  DatabaseCleaner.clean
end

###### Comments from the original env.rb about configuring DatabaseCleaner
# Note: We want to use transactions by default so they are aligned with rspec's default
# `use_transactional_fixtures` behavior.

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
# begin
#   DatabaseCleaner.strategy = :transaction
# rescue NameError
#   raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
# end

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
# Cucumber::Rails::Database.javascript_strategy = :truncation
