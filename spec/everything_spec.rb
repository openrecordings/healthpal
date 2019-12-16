require 'rails_helper'
RSpec.describe 'Everything' do
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
      submit_field = @driver.find_element(:id, 'login-button')
      sleep 2.0
      submit_field.click
      sleep 2.0
      expect(@driver.current_url).to eql('https://audiohealthpal.com/my_recordings')
      # Navigate to recording page
      @driver.find_element(:id, 'nav-new-recording').click
      sleep 1.5
      expect(@driver.current_url).to eql('https://audiohealthpal.com/record')
      # Record and upload
      @driver.find_element(:id, 'record-start-button').click
      sleep 1.5
      @driver.find_element(:id, 'record-stop-button').click
      sleep 1.5
      @driver.find_element(:id, 'save-button').click
      start_time = Time.now
      # Check every second for 30 seconds to see if the recording uploaded successfully
      while Time.now - start_time < 30
        sleep 2.0
        break if @driver.current_url.include?('https://audiohealthpal.com/my_recordings')
      end
      expect(@driver.current_url).to include('https://audiohealthpal.com/my_recordings')
      # Select a recording
      @driver.find_element(:link, 'Tue, Nov 26, 2019').click
      sleep 1.5
      expect(@driver.current_url).to include('https://audiohealthpal.com/play')
      # Play
      sleep 6.0
      @driver.find_element(:id, 'play').click
      sleep 4.0
      expect(@driver.find_element(:id, 'video-element').attribute('currentTime').to_i).to be > 0.0
    end
  end
end
