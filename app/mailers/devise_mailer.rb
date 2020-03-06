class DeviseMailer < Devise::Mailer
  helper :application

  default from: 'no-reply@audiohelthpal.com'

  layout 'mailer'
end
