class Message < ApplicationRecord

  belongs_to :recording

  # Called by Cron once per minute
  def self.send_due_messages
    send_now = Message.
      where('deliver_at < ?', DateTime.now).
      where(deliver: true).
      where('delivered_at is NULL')
    send_now.each{|m| MessageJob.perform_later(m); puts "Sending message ID #{m.id}"}
  end

end
