require 'rails_helper'

RSpec.describe 'Foo' do
  it 'can Bar' do
    @driver.get('https://www.saucedemo.com')
    puts "title of webpage is: #{@driver.title}"
    @driver.quit
    true
  end
end
