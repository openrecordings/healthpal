class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cache_buster
  after_action :track_action

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

  # Used in a before_filter in individual controllers for authorization.
  def only_admins
    redirect_to root_url unless current_user && current_user.privileged?
  end

  def track_action
    ahoy.track 'Request', request.path_parameters
  end

end
