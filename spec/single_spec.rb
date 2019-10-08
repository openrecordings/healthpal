require 'rails_helper'

RSpec.describe 'Login and record' do
  
  it 'can log in the test user' do
    @driver.navigate.to 'https://audiohealthpal.com'

    email_field = @driver.find_element(:id, 'user_email')
    password_field = @driver.find_element(:id, 'user_password')
    submit_field = @driver.find_element(:id, 'login-button')

    email_field.send_keys @test_user_email
    password_field.send_keys @test_user_password
    submit_field.click
    sleep 2
    expect(@driver.current_url).to eql('https://audiohealthpal.com/my_recordings')
  end

  it 'can navigate to recording page' do
    @driver.find_element(:href, '/record').click
    expect(@driver.current_url).to eql('https://audiohealthpal.com/record')
  end
end
