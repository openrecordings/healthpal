require_relative 'boot'

require 'rails/all'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Orals
  class Application < Rails::Application
    config.load_defaults '6.0'
    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_job.queue_adapter = :sidekiq

    # AWS hostname for the current environment
    config.hosts << Orals::Application.credentials[Rails.env.to_sym][:host]

    # Dockerize logs
		logger = ActiveSupport::Logger.new(STDOUT)
		logger.formatter = config.log_formatter
		config.log_tags = [:subdomain, :uuid]
		config.logger = ActiveSupport::TaggedLogging.new(logger)

  end
end
