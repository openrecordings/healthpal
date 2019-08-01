require_relative 'boot'

require 'rails/all'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Orals
  class Application < Rails::Application

		# Load env vars from local_env.yml
		config.before_configuration do
			env_file = File.join(Rails.root, 'config', 'local_env.yml')
			YAML.load(File.open(env_file)).each do |key, value|
				ENV[key.to_s] = value
			end if File.exists?(env_file)
		end

    config.load_defaults '6.0'
    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_job.queue_adapter = :sidekiq

    # Dockerize logs
		logger = ActiveSupport::Logger.new(STDOUT)
		logger.formatter = config.log_formatter
		config.log_tags = [:subdomain, :uuid]
		config.logger = ActiveSupport::TaggedLogging.new(logger)

  end
end
