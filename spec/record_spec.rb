require 'rails_helper'

RSpec.describe 'Login and record' do
  
  it 'can make a recording' do
    @driver.navigate.to 'https://audiohealthpal.com'

    # Log in
    email_field = @driver.find_element(:id, 'user_email')
    email_field.send_keys @test_user_email
    password_field = @driver.find_element(:id, 'user_password')
    password_field.send_keys @test_user_password
    submit_field = @driver.find_element(:id, 'login-button')
    # Time for JS to delete Ahoy cookie :(
    submit_field.click
    sleep 0.5
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
    start_time = Time.now
    # Check every second for 30 seconds to see if the recording uploaded successfully
    while Time.now - start_time < 30
      sleep 1
      break if @driver.current_url.include?('https://audiohealthpal.com/my_recordings')
    end
    expect(@driver.current_url).to include('https://audiohealthpal.com/my_recordings')
  end

end
