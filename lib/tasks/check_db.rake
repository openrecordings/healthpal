desc 'Run db:reset unless the database exists'
task check_db: :environment  do
  Rake::Task['db:reset'].invoke unless database_exists?
end

def database_exists?
	begin
	  ActiveRecord::Base.connection
	rescue ActiveRecord::NoDatabaseError
		false
	else
		true
  end
end
