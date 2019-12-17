desc 'Runs Selenium/Browserstack tests serially'
task :bs, [:targets, :runs] => :environment do |t, args|
  all_targets = YAML.load_file("#{Rails.root}/spec/browserstack.yml")
  successes = []
  failures = []
  targets = args[:targets]
  runs = args[:runs].to_i || 1
  help_and_exit(all_targets) unless targets
  if targets == 'all'
    targets = all_targets
  elsif targets.to_i.to_s == targets
    targets = [all_targets[targets.to_i - 1]]
  elsif targets.include?('..')
    targets = all_targets[eval(targets)]
  else
    help_and_exit(all_targets)
  end
  runs.times do
    targets.each do |target|
      target_description = "#{target['browser']} #{target['browser_version']} on #{target['os']} #{target['os_version']}:"
      puts
      puts "Testing against #{target_description}:"
      passed = !!system("export TASK_ID=#{all_targets.find_index(target)} && bundle exec rspec spec")
      passed ? (successes << target_description) : (failures << target_description)
    end
    puts
    puts "Results for tests completed at #{Time.now}"
    puts '----------------------------------------------------------------------------------------------------'
    puts 'Successes:'
    puts ap successes
    puts 'Failures:'
    puts ap failures
    puts
  end
end

def help_and_exit(all_targets)
  puts
  puts 'Target does not exist. Available targets are:'
  puts '----------------------------------------------------------------------------------------------------'
  puts 'all) Run against all targets'
  all_targets.each_with_index do |target, i|
    puts "#{i + 1}) #{target['browser']} #{target['browser_version']} on #{target['os']} #{target['os_version']}:"
  end
  puts
  exit 1
end
