class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception


  # Used in a before_filter in individual controllers for authorization.
  def only_admins
    redirect_to root_url unless current_user and current_user.privileged?
  end

	protected

  # Allow devise_invitable to handle the role parameter when creating users
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:invite, keys: [:role])
	end

end
