Rails.application.configure do

  config.require_master_key = true

  # Hide tags?
  hide_tags = Rails.application.credentials[Rails.env.to_sym][:hide_tags]
  ENV['HIDE_TAGS'] = 'true' if hide_tags

  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :ses
  config.action_mailer.default_url_options = {host: Rails.application.credentials[Rails.env.to_sym][:host]}
  config.action_mailer.raise_delivery_errors = true

  # Start vanilla Rails 6.0.0.RC1 production config
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = true
  config.assets.compile = false
  config.active_storage.service = :amazon
  config.log_level = :debug
  config.log_tags = [ :request_id ]
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
  config.active_record.dump_schema_after_migration = false
end
