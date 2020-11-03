class UserMailer < ApplicationMailer
  def reminder_1
    @recording = params[:message].recording
    mail(to: @recording.user.email, subject: 'A reminder to check out your recording')
  end

  def reminder_2
    @recording = params[:message].recording
    mail(to: @recording.user.email, subject: 'A reminder to check out your recording')
  end

  def reminder_3
    @recording = params[:message].recording
    mail(to: @recording.user.email, subject: 'Your next recorded visit is coming up')
  end
end
