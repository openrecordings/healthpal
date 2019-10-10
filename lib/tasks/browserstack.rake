# TODO: This should be replaced with parallel testing when we have a paid Browserstack account :(
desc 'Runs Selenium/Browserstack tests serially'
task :bs, [:target_index] => :environment do |t, args|
  target_index = args[:target_index]
  help_and_exit unless target_index
  all_targets = Rails.application.credentials.browserstack[:browser_caps]
  if target_index == 'all'
    targets = all_targets
  elsif target_index.is_a?(Integer) && target_index <= all_targets.length
    targets = all_targets[target_index - 1]
  else
    help_and_exit
  end
  targets.each_with_index do |target, i|
    puts
    puts "Testing against #{target[:browser]} #{target[:browser_version]} on #{target[:os]} #{target[:os_version]}:"
    puts '####################################################################################################'
    passed = !!system("export TASK_ID=#{i} && bundle exec rspec spec")
    exit 1 unless passed
  end
end

def help_and_exit
  all_targets = Rails.application.credentials.browserstack[:browser_caps]
  puts
  puts 'Target does not exist. Available targets are:'
  puts '####################################################################################################'
  puts 'all) Run against all targets'
  all_targets.each_with_index do |target, i|
    puts "#{i + 1}) #{target[:browser]} #{target[:browser_version]} on #{target[:os]} #{target[:os_version]}:"
  end
  puts
  exit 1
end
