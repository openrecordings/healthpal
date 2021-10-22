class MessageJob < ActiveJob::Base
  queue_as :message_jobs

  def perform(message)
    unless !!message.delivered_at
      send_email(message) if message.to_email
      send_sms(message) if message.to_sms
      # TODO Don't update if it didn't work
      message.update(delivered_at: Time.now)
    end
  end

  private

  def send_email(message)
    begin
      UserMailer.with(message:  message).send(message.mailer_method).deliver_now 
    rescue => exception
      puts exception
      puts 'EMAIL DELIVERY FAILED'
    end
  end


  def send_sms(message)
    user = message.user.nil? ? message.recording.user : message.user
    sms_text = user.send(message.sms_text_function)
    begin
      user.send_sms(sms_text)
    rescue => exception
      puts 'SMS DELIVERY FAILED'
    end
  end
end
