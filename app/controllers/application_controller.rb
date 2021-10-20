class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cache_buster
  before_action :check_layout
  around_action :set_locale
  after_action :log_request

  skip_before_action :authenticate_user!, only: [:set_locale_cookie]

  # Logs certain user actions which cannot be captured via AJAX because they result in a full page request
  LOGGED_ROUTES = [
    {
      controller: 'devise/sessions',
      rails_action: 'create',
      link_action: 'login-submit'
    },
    {
      controller: 'devise/passwords',
      rails_action: 'new',
      link_action: 'forgot-my-password'
    },
    {
      controller: 'devise/passwords',
      rails_action: 'create',
      link_action: 'send-password-reset-email'
    },
    {
      controller: 'play',
      rails_action: 'index',
      link_action: 'list-recordings'
    },
    {
      controller: 'record',
      rails_action: 'new',
      link_action: 'show-new-recording-page'
    }
  ].freeze

  # Set the locale for hte current request
  # 
  # The complexity here arises from the need to be able to set the locale while not signed in
  def set_locale(&action)
    # nil until set by user toggling locale the first time
    locale = cookies.encrypted[:locale]
    if params[:action] == 'set_locale_cookie' && I18n.available_locales.include?(params[:locale].to_sym)
      locale = params[:locale].to_sym
      cookies.encrypted[:locale] = { value: locale }
    end
    I18n.with_locale(locale || I18n.default_locale, &action)
  end

  # Dummy action so that locale cookie can be set with params[:locale]
  #
  # NOTE: Bypasses auth! Do not extend this method to do ANYTHING else!
  def set_locale_cookie
    render json: { status: 400 }
  end

  # Used in a before_filter in individual controllers for authorization.
  def only_admins
    redirect_to root_url unless current_user && current_user.privileged?
  end

  # Helper method for views that need to check the current path against one or more other paths
  # 
  # @param [String, Array<String>] paths
  def current_path_in?(paths)
    paths = [paths] if paths.is_a?(String)
    paths.include?(request.path) ? true : false
  end
  helper_method :current_path_in?

  protected

  # Allow devise_invitable to handle the added parameters when creating users
  def configure_permitted_parameters
    keys = %i[
      org_id
      role
      timezone_offset
      onboarded
      requires_phone_confirmation
      created_as_caregiver
    ]
    devise_parameter_sanitizer.permit(:invite, keys: keys)
    devise_parameter_sanitizer.permit(:register, keys: keys)
  end

  # Attempt to prevent browser caching. Helps mitigate back-button page renders after logout
  def set_cache_buster
    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

  # Hides the navbar for certain routes
  def check_layout
    if ['devise/sessions', 'devise/passwords',
        'invitations'].include? request.parameters['controller']
      @hide_navbar = true
    end
  end

  # Checks to see if the current_user is an admin or root 
  #
  # Called from controllers/actions that exclude regular [User]s.
  def verify_privileged
    unless current_user&.privileged?
      flash[:error] = 'You are not authorized to view that page'
      redirect_to :root
    end
  end

  def verify_not_va
    if current_user&.org_name == "VA"
      flash[:error] = 'You are not authorized to view that page'
      redirect_to :root
    end
  end

  # For specified routes, create a [Click] record for the incoming request
  def log_request
    route = LOGGED_ROUTES.find do |r|
      r[:controller] == request.parameters['controller'] && r[:rails_action] == request.parameters['action']
    end
    if route
      Click.create(
        user: current_user,
        client_ip_address: request.remote_ip,
        action: route[:link_action]
      )
    end
  end
end
