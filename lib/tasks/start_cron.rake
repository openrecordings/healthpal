desc 'Create long-running SendMessagesJob if needed'
task start_cron: :environment do
  SendMessagesJob.perform_later
end

