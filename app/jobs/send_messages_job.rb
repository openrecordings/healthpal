class SendMessagesJob < ActiveJob::Base
  # Don't add any more jobs to this queue
  queue_as :send_messages

  # This job never ends bail if the job already exists
  def perform
    return if Delayed::Job.where(queue: 'send_messages').any?
    while true
      send_due_messages
      sleep 60
    end
  end

  def send_due_messages
    send_now = Message.
      where('deliver_at < ?', DateTime.now).
      where(deliver: true).
      where('delivered_at is NULL')
    send_now.each{|m| MessageJob.perform_later(m); puts "Sending message #{m.id}"}
  end

end

