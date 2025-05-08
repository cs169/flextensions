source 'https://rubygems.org'

ruby '3.3.0'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.3'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgres for all env dbs
gem 'pg'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'lms-api'

gem 'newrelic_rpm'

# Use Active Storage for file uploads [https://guides.rubyonrails.org/active_storage_overview.html]
# gem "activestorage", "~> 7.0.0"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible [

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem 'bootstrap', '~> 5.3.3'
gem 'sassc-rails', '~> 2.1' # dependency for bootstrap #03-10-2025 this is deprecated but still works
# gem 'dartsass-sprockets' # alternative to sassc-rails, this is recommended but bootstrap 5.3.3 is still using "deprecated" @import statements which this gem doesn't like
gem 'json'

# Used to make http requests.
gem 'faraday'

# Used to allow dot notation of hashes.
gem 'ostruct'

# used to authenticate with the LMS
gem 'omniauth'
gem 'omniauth-oauth2'

# Font Awesome for icons
gem 'font-awesome-sass'

gem 'letter_opener'
gem 'letter_opener_web', '~> 3.0'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'rspec-retry'
  gem 'shoulda-matchers', '~> 5.0'
end

group :test do
  gem 'guard-rspec'
  gem 'rspec-rails'

  gem 'codeclimate-test-reporter'
  gem 'cucumber-rails', require: false
  gem 'cucumber-rails-training-wheels'
  gem 'database_cleaner'
  gem 'simplecov', '~> 0.20.0', require: false
  gem 'timecop'
  gem 'webmock'

  gem 'axe-core-api'
  gem 'axe-core-cucumber'
  gem 'axe-core-rspec'
  gem 'capybara-screenshot'
  gem 'rack_session_access'
  gem 'selenium-webdriver'
  gem 'simplecov_json_formatter'

  gem 'database_cleaner-active_record'

  # gem 'simplecov_json_formatter'
  # gem 'simplecov'#, '~> 0.21.2'
  # gem 'simplecov_json_formatter', '~> 0.1.4'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # TODO: Deprecate+remove this.
  gem 'byebug'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Ruby static code analyzer and formatter
  # TODO: Move these to a :linters, :development group
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

gem 'rails-controller-testing', '~> 1.0'

gem 'omniauth-canvas', '~> 2.0'
