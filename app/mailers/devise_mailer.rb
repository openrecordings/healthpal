class DeviseMailer < Devise::Mailer
  helper :application

  layout 'mailer'
end
