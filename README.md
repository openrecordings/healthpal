# README

Built with Ruby 2.2.2p95

Installation:

1. Clone the repo
2. Rename the application: https://github.com/morshedalam/rename
3. Create config/application.yml:  

        DATABASE_USER: your_db_user  
        DATABASE_PASSWORD: your_db_password  
        DATABASE_HOST: your_db_host (localhost for local development)  
        
4. create config/database.yml:  

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

5. Run "bundle exec rake db:reset"
6. Run "bundle exec rake db:migrate"
