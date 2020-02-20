class UserMailer < ApplicationMailer

  default from: 'no-reply@audiohealthpal.com'

  def user_message
    @message_template = params[:message_template]
    mail(to: params[:user].email, subject: @message_template.subject)
  end

end
