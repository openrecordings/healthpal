set :environment, 'development'
set :output, 'log/cron.log'

every 1.minute do
  runner 'Message.send_messages'
end
