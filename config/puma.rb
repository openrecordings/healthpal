set_default_host '0.0.0.0'
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count
environment ENV.fetch("RAILS_ENV") { "development" }
if [nil, 'development'].include? ENV.fetch("RAILS_ENV") 
  ssl_bind '0.0.0.0', '3001', {key: 'ssl/server.key', cert: 'ssl/server.crt'}
else
  port 3000
 end
plugin :tmp_restart
