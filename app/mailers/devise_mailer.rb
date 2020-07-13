class DeviseMailer < Devise::Mailer
  helper :application

  default from: 'no-reply@audiohealthpal.com'

  layout 'mailer'
end
