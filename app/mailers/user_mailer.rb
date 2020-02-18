class UserMailer < ApplicationMailer

  default from: 'no-reply@audiohealthpal.com'

  def message
    @template = params[:message_template]
    mail(to: params[:user].email, subject: @template.subject)
  end

end
