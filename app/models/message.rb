class Message < ApplicationRecord

  belongs_to :user
  belongs_to :message_template

  def self.send_messages
    UserMailer.with(recording: @recording).recording_ready.deliver_now
  end

end
