require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Orals
  class Application < Rails::Application
    config.load_defaults '6.0'
    config.time_zone = 'Eastern Time (US & Canada)'
    config.app_display_name = ENV['APP_DISPLAY_NAME']
    config.root_email = ENV['ROOT_EMAIL']
    config.root_password = ENV['ROOT_PASSWORD']
    config.research_mode = ENV['RESEARCH_MODE'] == 'true'
    config.twilio_account_sid = ENV['TWILIO_ACCOUNT_SID']
    config.twilio_auth_token = ENV['TWILIO_AUTH_TOKEN']
    config.twilio_from_phone_number = ENV['TWILIO_FROM_PHONE_NUMBER']
    config.cloud_provider = ENV['CLOUD_PROVIDER']

		# Google Cloud Platform Config
    config.gcp_app_credentials = ENV['GOOGLE_APPLICATION_CREDENTIALS']
    config.gcp_project_name =  ENV['GCP_PROJECT_NAME']
		config.gcp_bucket_name = ENV['GCP_BUCKET_NAME']

    # AWS config
    config.aws_bucket_name = ENV['AWS_BUCKET_NAME']
    
  end
end
