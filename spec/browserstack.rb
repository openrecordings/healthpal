require 'yaml'
require 'rspec'
require 'selenium-webdriver'
require 'browserstack/local'
TASK_ID = (ENV['TASK_ID'] || 0).to_i

RSpec.configure do |config|
	credentials = ::Rails.application.credentials
	server = credentials[:browserstack][:server]
	user = credentials[:browserstack][:user]
	key = credentials[:browserstack][:key]
	common_caps = credentials[:browserstack][:common_caps]
	browser_caps = credentials[:browserstack][:browser_caps]
  config.around(:example) do |example|
    @caps = common_caps.merge(browser_caps[TASK_ID])
    @caps["name"] = ENV['name'] || example.metadata[:name] || example.metadata[:file_path].split('/').last.split('.').first
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
