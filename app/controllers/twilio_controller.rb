require 'twilio-ruby'

class TwilioController < ApplicationController

  skip_before_action :authenticate_user! 

  def sms
    account_sid = 'ACfc5370662265436c172033646b756567'
    auth_token = '3496fa720b6266df2cad6a64ad7d0941'
    client = Twilio::REST::Client.new(account_sid, auth_token)
    from = '+18023920565'
    to = '+16033594675'
    begin
      client.api.account.messages.create(
        from: from,
        to: to,
        body: "Hey friend!"
      )
    rescue => e
			# TODO handle errors
    end
  end

end
