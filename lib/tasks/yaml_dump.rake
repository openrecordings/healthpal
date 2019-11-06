namespace :db do
  desc 'Export db to JSON'
  task to_yaml: :environment do
    path = Pathname("#{Rails.root}/dump")
    puts; puts 'WARNING: Never proceed with a database that includes PHI'
    puts 'WARNING: This will overwrite any data currently in ./dump'
    print 'Continue? (y/n) '
    unless STDIN.gets.strip == 'y'
      puts 'Abort!'; puts
      exit
    end
    `rm -rf #{path} ||:`
    `mkdir -p #{path}`

    tables = [
      'recordings',
      'users',
      'utterances',
      'user_fields',
      'active_storage_blobs',
      'active_storage_attachments',
    ]
    begin
      ActiveRecord::Base.establish_connection
      tables.each do |table_name|
        counter = '000'
        file_path = "#{Rails.root}/dump/#{table_name}.yml"
        File.open(file_path, 'w') do |file|
          rows = ActiveRecord::Base.connection.select_all("SELECT * FROM #{table_name}")
          data = rows.each_with_object({}) do |record, hash|
            suffix = record['id'].blank? ? counter.succ! : record['id']
            hash["#{table_name.singularize}_#{suffix}"] = record
          end
          puts "Writing table '#{table_name}' to '#{file_path}'"
          file.write(data.to_yaml)
        end
      end
    ensure
      ActiveRecord::Base.connection.close if ActiveRecord::Base.connection
    end
  end
end
