Devise.setup do |config|
  config.mailer = 'DeviseMailer'
  config.mailer_sender = 'no-reply@audiohealthpal.com'
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 11
  config.reconfirmable = false
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.timeout_in = 180.minutes
  config.reset_password_within = 6.hours
  Warden::Manager.before_logout do |user, auth, opts|
    user.disable_after_first_session!
  end
end
