# TODO: This should be replaced with parallel testing when we have a paid Browserstack account :(
desc 'Runs Selenium/Browserstack tests serially'
task browserstack: :environment do
  require 'rspec/core/rake_task'
  targets = Rails.application.credentials.browserstack[:browser_caps]
  targets.each_with_index do |target, i|
    puts
    puts "Testing against #{target[:browser]} #{target[:browser_version]} on #{target[:os]} #{target[:os_version]}:"
    puts '####################################################################################################'
    passed = !!system("ENV['TASK_ID']=#{i} bundle exec rspec spec")
    exit 1 unless passed
  end
end
