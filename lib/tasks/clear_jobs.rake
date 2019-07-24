require 'sidekiq/api'

desc 'Clear Redis queue and all Sidekiq jobs'
task clear_jobs: :environment do
  `redis-cli FLUSHALL`
  Sidekiq::RetrySet.new.clear
  Sidekiq::ScheduledSet.new.clear
end
