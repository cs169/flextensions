# frozen_string_literal: true

if ENV['SENTRY_DSN'].present?
  Sentry.init do |config|
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]
    config.dsn = ENV['SENTRY_DSN']
    config.traces_sample_rate = 1.0

    # Add data like request headers and IP for users,
    # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
    config.send_default_pii = false
  end
end
