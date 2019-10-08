require 'rails_helper'

RSpec.describe 'Login and record' do
  
  it 'can make a recording' do
    @driver.navigate.to 'https://audiohealthpal.com'

    # Log in
    email_field = @driver.find_element(:id, 'user_email')
    password_field = @driver.find_element(:id, 'user_password')
    submit_field = @driver.find_element(:id, 'login-button')
    email_field.send_keys @test_user_email
    password_field.send_keys @test_user_password
    submit_field.click
    sleep 0.5
    expect(@driver.current_url).to eql('https://audiohealthpal.com/my_recordings')

    # Navigate to recording page
    @driver.find_element(:id, 'nav-new-recording').click
    sleep 0.5
    expect(@driver.current_url).to eql('https://audiohealthpal.com/record')

    # Start recording
    @driver.find_element(:id, 'record-start-button').click
  end

end
