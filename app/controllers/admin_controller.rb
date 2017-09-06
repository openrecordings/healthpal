class AdminController < ApplicationController

  def index
  end

  def users
  end

  def toggle_otp
    user = User.find(params[:id])
    user.toggle_otp
    redirect_to :admin
  end

  # Start the workflow for doing an in-clinic user registration
  def new_registration
  end

  # Set password for in-clinic user registration
  def set_password
  end

  # Create new user using in-clinic registration
  def create_registation
  end

  # Switch to new user after in-clinic registration
  def switch_to_new_user
  end

end
