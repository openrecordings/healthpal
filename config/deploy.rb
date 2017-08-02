# config valid only for current version of Capistrano
lock ">=3.8.0"

set :application, "orals"
set :repo_url, "git@bitbucket.org:dartmouthinformatics/orals.git"
set :linked_files, %w{config/database.yml config/application.yml config/secrets.yml }
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system recordings_tmp}
set :deploy_to, '/home/rails/orals'
set :branch, 'master'
set :branch, ENV['BRANCH'] if ENV['BRANCH']
set :assets_roles, [:web, :app]

