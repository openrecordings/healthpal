class UserMailer < ApplicationMailer
  def r01_recording_ready
    @recording = params[:message].recording
    mail(to: @recording.user.email, subject: 'Your HealthPal audio recording is ready')
  end

  def r56_recording_ready
    @recording = params[:message].recording
    mail(to: @recording.user.email, subject: 'Your HealthPal audio recording is ready')
  end

  def r56_reminder_1
    @recording = params[:message].recording
    mail(to: @recording.user.email, subject: 'A reminder to check out your recording')
  end

  def r56_reminder_2
    @recording = params[:message].recording
    mail(to: @recording.user.email, subject: 'Your next recorded visit is coming up')
  end
end
