class Message < ApplicationRecord

  belongs_to :recording
  belongs_to :message_template

  # Called by Cron once per minute
  def self.send_due_messages
    send_now = Message.
      where('deliver_at < ?', DateTime.now).
      where(deliver: true).
      where('delivered_at is NULL')
    send_now.each{|message| MessageJob.perform_later(message)}
  end

end
