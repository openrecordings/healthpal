class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :verify_org
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cache_buster
  before_action :check_layout
  around_action :set_locale
  after_action :track_action
  around_action :set_locale

  skip_before_action :authenticate_user!, only: [:set_locale_cookie]

  def set_locale(&action)
    # nil until set either as user attribute or via the signin page
    locale = cookies[:locale]
    if current_user
      # Check a logged-in user's locale attribute. Changing the attribute is
      # done via AJAX then reload, so this works when changing the attribute
      locale = current_user.try(:locale) || cookies[:locale]
      cookies[:locale] = locale
    # Set the locale cookie via AJAX on public pages (have JS reload the page arterwards (await))
    elsif params[:action] == 'set_locale_cookie'
      # Set the locale cookie via a public page
      if I18n.available_locales.include?(params[:locale].to_sym)
        locale = params[:locale].to_sym
        cookies[:locale] = {value: locale}
      else
      end
    end
    I18n.with_locale(locale || I18n.default_locale, &action)
  end

  # Dummy action so that locale cookie can be set with params[:locale]
  def set_locale_cookie
    render json: { status: 400 }
  end

  # Used in a before_filter in individual controllers for authorization.
  def only_admins
    redirect_to root_url unless current_user && current_user.privileged?
  end

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

  def set_cache_buster
    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

  def check_layout
    if ['devise/sessions', 'devise/passwords', 'invitations'].include? request.parameters['controller']
      @hide_navbar = true
    end
  end

  def track_action
    ahoy.track 'Request', request.path_parameters
  end

  # Verify that the user has an Org when needed
  def verify_org
    # unless !!!current_user || current_user.root? || !!current_user.org
    #   flash[:error] = 'You are not authorized to view that page'
    #   redirect_to :root
    # end
  end

  # Called from controllers/actions that exclude regular users.
  def verify_privileged
    unless current_user.privileged?
      flash[:error] = 'You are not authorized to view that page'
      redirect_to :root
    end
  end
end
