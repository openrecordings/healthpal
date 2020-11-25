class HomeController < ApplicationController

  def index
    if current_user.onboarded || session[:dont_onboard]
      redirect_to (current_user&.privileged? ? :admin : :play)
    else
      redirect_to intro_video_url
    end
  end

  # AJAX GET endpoint for setting a user's locale
  # Since there are only two languages as of now, the db state tells us what to do
  # nil -> es
  # en  -> es
  # es  -> en
  # Also set the locale in the cookie so that it's in sync after session termination
  def toggle_locale
    current_locale = cookies.encrypted[:locale] || current_user.locale
    new_locale = [nil, 'en'].include?(current_locale) ? 'es' : 'en'
    current_user.update locale: new_locale
    cookies.encrypted[:locale] = {value: new_locale}
    render json: {status: 200} 
  end

end
