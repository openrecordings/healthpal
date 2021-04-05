class UserMailer < ApplicationMailer

  default from: 'no-reply@audiohealthpal.com'

  def r01_recording_ready
    @recording = params[:message].recording
    mail(to: @recording.user.email, subject: 'Your HealthPAL audio recording is ready')
  end

end
