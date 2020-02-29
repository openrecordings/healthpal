class MessageJob < ActiveJob::Base
  queue_as :message_jobs

  def perform(message)
    UserMailer.with(message:  message).send(message.mailer_method).deliver_now 
    message.update(delivered_at: Time.now)
  end

end
