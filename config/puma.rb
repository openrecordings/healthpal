set_default_host '0.0.0.0'
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count
environment ENV.fetch("RAILS_ENV") { "development" }
plugin :tmp_restart
port 3000
# From https://gist.github.com/tadast/9932075#file-ssl_puma-sh
# NOTE SSL not working w Docker as of 2019-07-30
if ENV.fetch("RAILS_ENV") == 'development'
  ssl_bind '127.0.0.1', '3000', {
    key: Orals::Application.credentials.ssl_key_path,
    cert: Orals::Application.credentials.ssl_cert_path,
    verify_mode: 'none'
  }
end
