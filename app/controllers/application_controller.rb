class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :check_otp_status, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cache_buster

  # Used in a before_filter in individual controllers for authorization.
  def only_admins
    redirect_to root_url unless current_user and current_user.privileged?
  end

	protected

  # Allow devise_invitable to handle the role parameter when creating users
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:invite, keys: [:role])
	end

  # Prevent application access unless OTP sign up is complete
  def check_otp_status
    if current_user.otp_mandatory
      redirect_to :user_otp_token unless current_user.otp_enabled
    end
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

end
