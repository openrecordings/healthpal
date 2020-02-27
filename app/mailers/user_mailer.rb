class UserMailer < ApplicationMailer

  default from: 'no-reply@audiohealthpal.com'

  def user_message
    @message_template = params[:message_template]
    mail(to: params[:user].email, subject: @message_template.subject)
  end

  def recording_ready
    @recording = params[:recording]
    mail(to: @recording.user.email, subject: 'Your HealthPal audio recording is ready')
  end

end
