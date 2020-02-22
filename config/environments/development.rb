Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  
  # config.assets.prefix = '/dev-assets'

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Dev only 
  config.serve_static_assets = false

	config.action_mailer.smtp_settings = {
		:address => Rails.application.credentials[:staging][:ses_smtp_server_address],
		:port => 25,
		:user_name => Rails.application.credentials[:staging][:ses_smtp_user_name],
		:password => Rails.application.credentials[:staging][:ses_smtp_password],
		:authentication => :login,
		:enable_starttls_auto => true
	}

  # Staging and production:
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = {host: Rails.application.credentials[:staging][:host]}
  config.action_mailer.raise_delivery_errors = true

  # send email in development. Configured for Letter Opener
  # config.action_mailer.perform_deliveries = true
  # config.action_mailer.delivery_method = :letter_opener
  # config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
