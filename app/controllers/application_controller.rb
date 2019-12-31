class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cache_buster
  around_action :set_locale
  after_action :track_action

  # app-level config (factor this out if app_config.yml ends up with more than one entry)
  #################################################################################################
  def hide_tags_in_playback
    begin
      return Rails.application.config.hide_tags_in_playback
    rescue
      return false
    end
  end
  helper_method :hide_tags_in_playback
  #################################################################################################

  # Used in a before_filter in individual controllers for authorization.
  def only_admins
    redirect_to root_url unless current_user and current_user.privileged?
  end

  protected

  # Allow devise_invitable to handle the role parameter when creating users
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: [:role])
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

	def set_locale(&action)
		locale = current_user.try(:locale) || I18n.default_locale
		I18n.with_locale(locale, &action)
	end

  def track_action
    ahoy.track 'Request', request.path_parameters
  end

  # Called from controllers/actions that exclude regular users.
  def verify_privileged
    unless current_user.privileged?
      flash[:error] = 'You are not authorized to view that page'
      redirect_to :root
    end
  end

end
