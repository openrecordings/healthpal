class UserMailer < ApplicationMailer

  default from: 'no-reply@audiohealthpal.com'

  def recording_ready
    @recording = params[:recording]
    mail(to: @recording.user.email, subject: 'Your HealthPal audio recording is ready')
  end

end
