#browserstack
require 'yaml'
require 'rspec'
require 'selenium-webdriver'
require 'browserstack/local'
TASK_ID = (ENV['TASK_ID'] || 0).to_i

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'development'
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

  # Browserstack
  #################################################################################################

  # Browserstack credentials and config
  browserstack_config = Rails.application.credentials.browserstack
  server = browserstack_config[:server]
  user = browserstack_config[:user]
  key = browserstack_config[:key]
  common_caps = browserstack_config[:common_caps]
  browser_caps = browserstack_config[:browser_caps]

  config.around(:example) do |example|
    # Test user credentials
    @test_user_email = browserstack_config[:test_user_email]
    @test_user_password = browserstack_config[:test_user_password]

    task_id = ENV['TASK_ID'].to_i || 0

    browser_caps = browser_caps[task_id]
    browser = browser_caps[:browser]
    @caps = common_caps.merge(browser_caps)
    @caps['name'] = ENV['name'] || example.metadata[:name] || example.metadata[:file_path].split('/').last.split('.').first

    # Microphone access
    case browser
    when 'chrome'
      @caps['chromeOptions'] = {}
      @caps['chromeOptions']['args'] = [
        '--allow-file-access-from-files',
        '--use-fake-device-for-media-stream',
        '--use-fake-ui-for-media-stream']
    when 'firefox'
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['permissions.default.microphone'] = 1
      @caps = Selenium::WebDriver::Remote::Capabilities.firefox({firefox_profile: profile}.merge(@caps))
    when 'Edge'
      # TODO: Get this working
      options = Selenium::WebDriver::Edge::Options.new({'permissions.default.microphone': 1}.merge(@caps))
      @caps = Selenium::WebDriver::Remote::Capabilities.edge(options)
    end

    enable_local = @caps["browserstack.local"] && @caps["browserstack.local"].to_s == "true"

    # Code to start browserstack local before start of test
    if enable_local
      @bs_local = BrowserStack::Local.new
      bs_local_args = { "key" => key, "forcelocal" => true }
      @bs_local.start(bs_local_args)
      @caps["browserstack.local"] = true
    end

    @driver = Selenium::WebDriver.for(:remote,
      :url => "http://#{user}:#{key}@#{server}/wd/hub",
      :desired_capabilities => @caps)

    begin
      example.run
    ensure 
      @driver.quit
      # Code to stop browserstack local after end of test
      @bs_local.stop if enable_local
    end
  end

end
