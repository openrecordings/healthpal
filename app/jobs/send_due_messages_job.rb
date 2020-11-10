class SendDueMessagesJob < ActiveJob::Base
  queue_as :send_due_messages_jobs

  # NOTE: Don't instantiate this job from within the app. It is called once after initialiation
  #       (see application.rb) and never terminates during the app lifecycle
  def perform
    Message.send_due_messages
    SendDueMessagesJob.set(wait: 5.minutes).perform_later
  end
end
