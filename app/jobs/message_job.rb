class MessageJob < ActiveJob::Base
  queue_as :messages

  def perform(message_template, user)
    UserMailer.with(message_template: message_template, user: user).message.deliver 
  end

end
