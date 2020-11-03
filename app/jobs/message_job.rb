class MessageJob < ActiveJob::Base
  queue_as :message_jobs

  def perform(message)
    if message.to_email
      UserMailer.with(message:  message).send(message.mailer_method).deliver_now 
    end
    if message.to_sms
      user = message.recording.user
      sms_text = "#{I18n.t("
    end
    message.update(delivered_at: Time.now)
  end


end
