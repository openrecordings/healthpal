class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cache_buster
  before_action :check_layout
  around_action :set_locale
  after_action :track_action

  # Used in a before_filter in individual controllers for authorization.
  def only_admins
    redirect_to root_url unless current_user and current_user.privileged?
  end

  def current_path_in?(paths)
    paths = [paths] if paths.is_a?(String)
    paths.include?(request.path) ? true : false
  end
  helper_method :current_path_in?

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

  def check_layout
    @hide_navbar = true if ['devise/sessions'].include? request.parameters['controller']
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
