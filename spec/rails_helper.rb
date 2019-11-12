require 'yaml'
require 'rspec'
require 'selenium-webdriver'
require 'spec_helper'

ENV['RAILS_ENV'] ||= 'development'
TASK_ID = (ENV['TASK_ID'] || 0).to_i
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  # Saucelabs
  #################################################################################################
  config.around(:example) do |example|
    saucelabs_config = Rails.application.credentials.saucelabs
    browser_caps = saucelabs_config[:browser_caps][0]
    @test_user_email = saucelabs_config[:test_user_email]
    @test_user_password = saucelabs_config[:test_user_password]
    @caps = {
        platform: browser_caps[:platform_name],
        browser_name: browser_caps[:browser_name],
        browser_version: browser_caps[:browser_version],
        screen_resolution: browser_caps[:screen_resolution],
        name: 'HealthPAL test'
    }

    # Microphone access
    case browser_caps[:browser_name]
    when 'chrome'
      @caps['chromeOptions'] = {}
      @caps['chromeOptions']['args'] = [
        '--allow-file-access-from-files',
        '--use-fake-device-for-media-stream',
        '--use-fake-ui-for-media-stream']
      @driver = Selenium::WebDriver.for(
        :chrome,
        url: Rails.application.credentials.saucelabs[:driver_url],
        desired_capabilities: @caps)
    when 'firefox'
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['permissions.default.microphone'] = 1
      options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
      options.add_preference('permissions.default.microphone', 1)
      options.add_preference('permissions.default.camera', 1)
      # options.add_preference('dom.webnotifications.enabled', 0)
      options.add_preference('media.navigator.permission.disabled', 1)
      # options.add_argument('use-fake-ui-for-media-stream')
      @driver = Selenium::WebDriver.for(
        :remote,
        url: Rails.application.credentials.saucelabs[:driver_url],
        desired_capabilities: @caps,
        options: options)
    when 'Edge'
      # TODO: Get this working
      # options = Selenium::WebDriver::Edge::Options.new({'permissions.default.microphone': 1}.merge(@caps))
      # @caps = Selenium::WebDriver::Remote::Capabilities.edge(options)
    end
  
    begin
      example.run
    ensure 
      @driver.quit
    end
  end
  #################################################################################################
end
