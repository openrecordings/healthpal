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
<<<<<<< HEAD:spec/rails_helper_browserstack.rb

  ## The code below configures Rspec, a testing framework for Ruby, to interact with the
  ## browserstack.com API. The only tricky thing is accessing the microphone. We need Selenium
  ## to access the microphone in order to test recording, and the way you set this configurations
  ## is browser-specific. I think that the "Microphone access" section is the only thing that will
  ## need editing as we add more browsers. That section is a case statement (switch) where each
  ## target browser is a case. You can see that I've got it working on Chrome and Firefox, but Edge
  ## is not working yet, and I haven't yet looked into others. Here are two key links for working
  ## on this file:
  ##
  ##  https://github.com/SeleniumHQ/selenium/wiki/Ruby-Bindings - Docs for Selenium Ruby bindings
  ##  https://www.browserstack.com/automate/capabilities - Browserstack-specific config

  # Browserstack
  #################################################################################################
  # Credentials and config
  browserstack_config = Rails.application.credentials.browserstack
  server = browserstack_config[:server]
  user = browserstack_config[:user]
  key = browserstack_config[:key]

=======
  # Saucelabs
  #################################################################################################
>>>>>>> dev:spec/rails_helper.rb
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
