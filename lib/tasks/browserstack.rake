# TODO: This should be replaced with parallel testing when we have a paid Browserstack account :(

## Below is what's called a "Rake task" in Ruby. It's anagous to "make" in C. There is one task,
## called "bs". You run it from the command line and takes one required argument. That argument is
## tells the task either to test against all of the configurations (device, os, browser), or to test
## against just one of them. Here are a couple of examples of running it.
##
##  bundle exec rake bs[all]
##  bundle exec rake bs[3]
##
## "bundle exec" gives rake acces to all of the libraries ("gems" in Ruby) that the application uses.
## "rake" is the actual command, "bs" tells it which task to run, and the argument to the task is
## in the brakets. "all" will force all targets to be tested, where as "3" will only test the
## third configured target. These targets are configured in /config/credentials.yml.enc, an
## encrypted file. In order to edit that file, you can use this command:
##
##  EDITOR=vim rails credentials:edit
##
## This is a YAML file. If you haven't used YAML, 5 minutes of reading will get you going, it's 
## like JSON, but even simpler. Here, for example is the beginning of the target list in
## credentials.yml.enc, including only the first target:
##
##    browser_caps:
##  -
##       os: Windows
##       os_version: 10
##       browser: chrome
##       browser_version: 77.0
##       resolution: 1024x768
##
## You may not need to edit this file. It will need editing if, for example, we want to be able
## to pass an argument that says "test on all of the mobile targets" or similar.

desc 'Runs Selenium/Browserstack tests serially'
task :bs, [:target_index] => :environment do |t, args|
  successes = 0
  failures = 0
  target_index = args[:target_index]
  help_and_exit unless target_index
  all_targets = Rails.application.credentials.browserstack[:browser_caps]
  if target_index == 'all'
    targets = all_targets
  elsif target_index.to_i.is_a?(Integer) && target_index.to_i <= all_targets.length
    targets = [all_targets[target_index.to_i - 1]]
  else
    help_and_exit
  end
  targets.each do |target|
    puts
    puts "Testing against #{target[:browser]} #{target[:browser_version]} on #{target[:os]} #{target[:os_version]}:"
    puts '####################################################################################################'
    puts "Successes so far: #{successes}"
    puts " Failures so far: #{failures}"
    passed = !!system("export TASK_ID=#{all_targets.find_index(target)} && bundle exec rspec spec")
    passed ? (successes += 1) : (failures += 1)
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
