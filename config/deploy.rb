# config valid only for current version of Capistrano
lock ">=3.7.1"

set :application, "orals"
set :repo_url, "git@bitbucket.org:dartmouthinformatics/orals.git"
set :linked_files, %w{config/database.yml config/application.yml config/secrets.yml }
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :deploy_to, '/home/rails/orals'
set :branch, 'master'
set :branch, ENV['BRANCH'] if ENV['BRANCH']
set :assets_roles, [:web, :app]

