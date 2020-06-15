class HomeController < ApplicationController

  def index
    if current_user.onboarded || session[:dont_onboard]
      redirect_to (current_user&.privileged? ? :admin : :play)
    else
      redirect_to intro_video_url
    end
  end

end
