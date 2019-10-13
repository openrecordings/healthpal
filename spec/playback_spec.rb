require 'rails_helper'

RSpec.describe 'Playback' do
  
  it 'can play a recording' do
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

    # Select a recording
    @driver.find_element(:link, 'Sat, Jan 1, 2000').click
    sleep 0.5
    expect(@driver.current_url).to include('https://audiohealthpal.com/play')

    # Play
    sleep 4.0
    @driver.find_element(:id, 'play').click
    sleep 2.0
    expect(@driver.find_element(:id, 'video-element').attribute('currentTime').to_i).to be > 0.5
  end

end

