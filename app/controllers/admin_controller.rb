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
    @user = User.new(email: params[:email])
  end

  # Set password for in-clinic user registration
  def set_password
    @user = User.new(email: user_params[:email])
  end

  # Create new user using in-clinic registration
  def create_registration
    @user = User.new(
      email: user_params[:email],
      password: user_params[:password],
      role: 'user'
    )
    if @user.save
      sign_in @user
      redirect_to :root and return
    else
      flash.alert = @user.errors.full_messages
      redirect_to new_registration_path(email: @user.email)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
