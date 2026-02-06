source 'https://rubygems.org'

ruby '~> 3.3.7'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.2.3'

# Use postgres for all env dbs
gem 'pg'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 6.0'

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

# Alternative Canvas API. We probably don't need this.
# Verify instances of `LMS::Canvas`
gem 'lms-api'

# TODO: Not used with UCB env, but used on Heroku.
gem 'sentry-ruby'
gem 'sentry-rails'

gem 'json'

# Used to make http requests.
gem 'faraday'
gem 'faraday-cookie_jar'

# Used to allow dot notation of hashes.
gem 'ostruct'

# used to authenticate with the LMS
gem 'omniauth'
gem 'omniauth-canvas'
gem 'omniauth-oauth2'

# Audit for potentially unsafe database migrations
gem 'strong_migrations'

# Logging Customization
gem 'lograge'

# Use Active Storage for file uploads [https://guides.rubyonrails.org/active_storage_overview.html]
# gem "activestorage", "~> 7.0.0"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

## BI and Admin Dashboard Tools
#
gem 'blazer'
gem 'hypershield'

#### Frontend related tools
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

gem 'bootstrap', '~> 5.3.8'
# dependency for bootstrap # 03-10-2025 this is deprecated but still works
gem 'sassc-rails', '~> 2.1'
# alternative to sassc-rails, this is recommended but bootstrap 5.3.3 is still using "deprecated" @import statements which this gem doesn't like
# gem 'dartsass-sprockets'

# Font Awesome for icons
gem 'font-awesome-sass'

group :test do
  gem 'rspec-rails'

  gem 'cucumber-rails', require: false

  # TODO: Rewrite Tests / Deprecate this.
  gem 'rails-controller-testing', '~> 1.0'

  # accessibility testing.
  gem 'axe-core-cucumber'
  gem 'axe-core-rspec'

  gem 'capybara-screenshot'
  gem 'codeclimate-test-reporter'
  # Database Cleaner is used only with Cucumber
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'guard-rspec'
  gem 'rack_session_access'
  gem 'rspec-retry'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 7.0'
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'simplecov_json_formatter'
  gem 'timecop'
  gem 'webmock'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Nice references to routes/db schema in files
  gem 'annotaterb'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]
end

# Tools, incase you need to install just the linters
# This may be useful if you use Docker for dev, but want to run
# them locally.
group :development, :test, :linters do
  gem 'brakeman'

  # Ruby static code analyzer and formatter
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails-omakase', require: false
  gem 'rubocop-rspec', require: false
end

# Everywhere except :production
group :development, :staging do
  # Include letter opening in staging so we can view emails without actually nagging humans.
  gem 'letter_opener'
  gem 'letter_opener_web', '~> 3.0'
end

# Staging only gems.
# group :staging do
# end
