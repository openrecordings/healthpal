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
  bs_config = HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/browserstack.yml"))
  targets = YAML.load_file("#{Rails.root}/spec/browserstack.yml")
  config.around(:example) do |example|
    target_index = ENV['TASK_ID'].to_i || 0
    @test_user_email = bs_config[:healthpal_user]
    @test_user_password = bs_config[:healthpal_password]
    @caps = bs_config.merge(targets[target_index])
    @caps['browserstack.networkLogs'] = true
    @caps['browserstack.console'] = 'errors'
    case @caps['browser']
    when 'Chrome'
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
    end
    @driver = Selenium::WebDriver.for(:remote,
      url: "http://#{@caps['user']}:#{@caps['key']}@#{@caps['server']}/wd/hub",
      desired_capabilities: @caps)
    begin
      example.run
    ensure 
      @driver.quit
    end
  end
  #################################################################################################
end
