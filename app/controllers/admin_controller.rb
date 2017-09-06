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
    # Creating a new user to hold params, but we're only going to set the email now
    @user = User.new
  end

  # Set password for in-clinic user registration
  def set_password
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    puts params.require(:user).permit(:email)[:email]
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
  end

  # Create new user using in-clinic registration
  def create_registation
  end

  # Switch to new user after in-clinic registration
  def switch_to_new_user
  end

end
