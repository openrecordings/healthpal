class MessageJob < ActiveJob::Base
  queue_as :message_jobs

  def perform(message_template, user)
    UserMailer.with(message_template: message_template, user: user).user_message.deliver_now 
  end

end
