class Message < ApplicationRecord

  belongs_to :recording
  belongs_to :message_template

  # Called by Cron once per minute
  def self.send_messages
    send_now = Message.
      where('deliver_at < ?', DateTime.now).
      where(deliver: true).
      where('delivered_at is NULL')
    send_now.each do |m|
      MessageJob.perform_later(m.message_template, m.recording.user)  
      m.update(delivered_at: Time.now)
    end
  end

end
