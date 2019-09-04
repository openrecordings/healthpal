class HelpController < ApplicationController

  def intro_video
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
