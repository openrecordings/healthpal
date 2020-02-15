class UserMailer < ApplicationMailer

  default from: 'no-reply@audiohealthpal.com'

  def recording_ready
    @recording = params[:recording]
    mail(to: Recording.find(5).user.email, subject: 'Your HealthPAL audio recording is ready')
  end

end
