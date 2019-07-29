set_default_host '0.0.0.0'
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count
environment ENV.fetch("RAILS_ENV") { "development" }
plugin :tmp_restart
# From https://gist.github.com/tadast/9932075#file-ssl_puma-sh
if ENV.fetch("RAILS_ENV") == 'development'
  port 3000
  ssl_bind '127.0.0.1', '3000', {
    key: Orals::Application.credentials.ssl_key_path,
    cert: Orals::Application.credentials.ssl_cert_path,
    verify_mode: 'none'
  }
else
  port 80
end
