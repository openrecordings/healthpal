require 'rails_helper'

RSpec.describe 'Google search' do
  it 'can find search results' do
    @driver.navigate.to 'https://www.google.com/ncr'
    element = @driver.find_element(:name, 'q')
    element.send_keys 'BrowserStack'
    element.submit
    sleep 5
    expect(@driver.title).to eql('BrowserStack - Google Search')
  end
end
