class UserMailer < ApplicationMailer
 
  def uploaded_alert_cg
    @recording = params[:message].recording
    @user = params[:message].user.nil? ? @recording.user : params[:message].user
    mail(
      from: 'no-reply@va.audiohealthpal.com',
      to: @user.email,
      subject: 'A reminder to check out your recording'
    )    
  end

  def reminder_1
    @recording = params[:message].recording
    mail(
      from: 'no-reply@va.audiohealthpal.com',
      to: @recording.user.email,
      subject: 'A reminder to check out your recording'
    )
  end

  def reminder_2
    @recording = params[:message].recording
    mail(
      from: 'no-reply@va.audiohealthpal.com',
      to: @recording.user.email,
      subject: 'A reminder to check out your recording'
    )
  end

  def reminder_3
    @recording = params[:message].recording
    mail(
      from: 'no-reply@va.audiohealthpal.com',
      to: @recording.user.email,
      subject: 'Your next recorded visit is coming up'
    )
  end
end
