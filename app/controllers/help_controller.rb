class HelpController < ApplicationController
  def index
    @video = I18n.locale == :es ? 'intro_video_es.mp4' : 'intro_video.mp4'
  end

  def intro_video
    @video = I18n.locale == :es ? 'intro_video_es.mp4' : 'intro_video.mp4'
  end

  def dont_onboard
    session[:dont_onboard] = true
    redirect_to root_url
  end

  def set_onboarded
    current_user.update onboarded: true
    redirect_to root_url
  end

  def view_transcript
    @recording = Recording.find(params[:id])
    render layout: false
  end
end
