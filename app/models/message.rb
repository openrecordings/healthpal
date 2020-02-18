class Message < ApplicationRecord

  belongs_to :user
  belongs_to :message_template

  def self.send_messages
    UserMailer.with(recording: Recording.find(3)).recording_ready.deliver_now
  end

end
