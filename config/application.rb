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

    config.audio_encryption_key = ENV['AUDIO_ENCRYPTION_KEY']
    config.tag_types = ENV['TAG_TYPES']&.split(',')

  end
end
