class ApplicationMailer < ActionMailer::Base
  helper :application

  default from: 'from@example.com'
  layout 'mailer'
end
