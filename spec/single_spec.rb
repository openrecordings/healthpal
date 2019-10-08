require 'rails_helper'

RSpec.describe 'Login' do
  it 'can log in the test user' do
    @driver.navigate.to 'https://audiohealthpal.com'

    email_field = @driver.find_element(:id, 'user_email')
    password_field = @driver.find_element(:id, 'user_password')
    submit_field = @driver.find_element(:id, 'login-button')

    email_field.send_keys @test_user_email
    password_field.send_keys @test_user_password
    submit_field.click
    sleep 2
    expect(@driver.getCurrentUrl).to eql('https://audiohelahpal.com/my_recordings')
  end
end
