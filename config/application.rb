require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Orals
  class Application < Rails::Application
    config.time_zone = 'Eastern Time (US & Canada)'

    config.app_display_name = ENV['APP_DISPLAY_NAME']

    config.root_email = ENV['ROOT_EMAIL']
    config.root_password = ENV['ROOT_PASSWORD']

    config.research_mode = ENV['RESEARCH_MODE'] == 'true'

		# Google Cloud Platform Config
    config.local_audio_file_path = Rails.root.join('encrypted_audio')
		config.bucket_name = ENV['GCP_BUCKET_NAME']
		

  end
end
