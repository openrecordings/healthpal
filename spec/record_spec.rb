require 'rails_helper'

## This are the test instructions for recording. The comments divide the code into the different
## user actions that are simulated. Use this code as a cheat sheet for writing tests that test
## other functionality. The lines that start with "expect" are the actual boolean pass/fail tests
## if any one of them fails, the whole thing fails. There are many kinds of boolean tests you can
## use to verify that the code is working correctly. See:
##   https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers

RSpec.describe 'Recording' do
  
  it 'can make a recording' do
    # TODO: Remove conditional once Selenium microphone access with Edge is working
    if @browser == 'Edge'
      puts 'SKIPPING Edge recording test'
      true
    else
      @driver.navigate.to 'https://audiohealthpal.com'

      # Log in
      email_field = @driver.find_element(:id, 'user_email')
      email_field.send_keys @test_user_email
      sleep 0.5
      password_field = @driver.find_element(:id, 'user_password')
      password_field.send_keys @test_user_password
      sleep 0.5
      submit_field = @driver.find_element(:id, 'login-button')
      submit_field.click
      sleep 1.0
      expect(@driver.current_url).to eql('https://audiohealthpal.com/my_recordings')

      # Navigate to recording page
      @driver.find_element(:id, 'nav-new-recording').click
      sleep 0.5
      expect(@driver.current_url).to eql('https://audiohealthpal.com/record')

      # Record and upload
      @driver.find_element(:id, 'record-start-button').click
      sleep 0.5
      @driver.find_element(:id, 'record-stop-button').click
      sleep 0.5
      @driver.find_element(:id, 'save-button').click

      # Check every second for 30 seconds to see if the recording uploaded successfully
      start_time = Time.now
      while Time.now - start_time < 30
        sleep 1
        break if @driver.current_url.include?('https://audiohealthpal.com/my_recordings')
      end
      expect(@driver.current_url).to include('https://audiohealthpal.com/my_recordings')
      end
  end

end
