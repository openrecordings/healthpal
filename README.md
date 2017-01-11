# README

Built with Ruby 2.2.2p95

Installation:

1. Clone the repo
2. ```bundle install```
3. Rename the application: https://github.com/morshedalam/rename
4. Create config/application.yml:  

        ROOT_EMAIL: some_email
        ROOT_PASSWORD: some_password
        DATABASE_USER: your_db_user  
        DATABASE_PASSWORD: your_db_password  
        DATABASE_HOST: your_db_host (localhost for local development)  

5. create config/database.yml:  

        default: &default  
          adapter: postgresql  
          encoding: unicode
          username: <%= ENV['DATABASE_USER'] %>
          password: <%= ENV['DATABASE_PASSWORD'] %>
          host: <%= ENV['DATABASE_HOST'] %>
          pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

        development:
          <<: *default
          database: your_app_name_development

        test:
          <<: *default
          database: your_app_name_test

        production:
          <<: *default
          database: your_app_name_production

6. ```bundle exec rake db:reset```
7. ```bundle exec rake db:migrate```
