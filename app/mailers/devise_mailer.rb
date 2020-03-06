class DeviseMailer < Devise::Mailer
  helper :application

  default from: 'will.haslett@dartmouth.edu'

  layout 'mailer'
end
