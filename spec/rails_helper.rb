require 'yaml'
require 'rspec'
require 'selenium-webdriver'
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
  # Saucelabs
  #################################################################################################
  config.around(:example) do |example|
    @caps = {
        platform: 'macOS 10.13',
        browserName: 'Safari',
        version: '11.1',
        build: 'Onboarding Sample App - Ruby',
        name: '1-first-test'
    }
    @driver = Selenium::WebDriver.for(:remote,
      :url => Rails.application.credentials.saucelabs[:driver_url],
      :desired_capabilities => @caps)
    begin
      example.run
    ensure 
      @driver.quit
    end
  end
  #################################################################################################
end
