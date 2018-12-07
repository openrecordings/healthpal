source 'https://rubygems.org'

gem 'haml'
gem 'devise'
gem 'devise-otp-rails5', require: 'devise-otp'
gem 'devise_invitable', '~> 1.7.0'
gem 'awesome_print'
gem 'rspec-rails'
gem 'figaro'
gem 'twitter-bootstrap-rails'
gem 'bootstrap_form'
gem 'font-awesome-rails'
gem 'jquery-tablesorter'
gem 'tether-rails'
gem 'paperclip', '>= 5.2.0'
gem 'delayed_job_active_record'
gem 'rename'
gem 'capistrano'
gem 'capistrano-passenger'
gem 'capistrano-bundler'
gem 'capistrano-rails'
gem 'capistrano-rbenv'
gem 'attr_encrypted'
gem 'bootstrap-editable-rails'
gem 'coffee-rails', '~> 4.2'
gem 'nokogiri', '>= 1.8.2'
gem 'loofah', '>= 2.2.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
 
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'select2-rails', '~> 4.0', '>= 4.0.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Vim in the REPL :)
  gem 'interactive_editor'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
