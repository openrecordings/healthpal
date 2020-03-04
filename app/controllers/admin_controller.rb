class AdminController < ApplicationController

  #TODO Handle bad params
  
  before_action :verify_privileged

  def index
  end

  def users
  end

  def manage_recordings
    @recordings = Recording.all.order('created_at desc')
  end

  def create_tag
  end

  def toggle_active
    user = User.find(params[:id])
    user.toggle_active
    redirect_to :admin
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
    @user = User.new(user_params)
  end

  # Create and swtich to new user
  def create_registration
    @user = User.new(
      first_name: user_params[:first_name],
      last_name: user_params[:last_name],
      email: user_params[:email],
      phone_number: user_params[:phone_number],
      password: user_params[:password],
      role: 'user',
      requires_phone_confirmation: false
    )
    if @user.save
      sign_in @user
      redirect_to :root and return
    else
      flash.alert = @user.errors.full_messages
      redirect_to new_registration_path(email: @user.email)
    end
  end

  # Select an existing user to switch to
  def switch_user_select
    @users = User.regular
  end

  def switch_to_user
    user = User.find_by(id: params[:user_id])
    if user
      reset_session
      sign_in user
    else
      flash.now[:alert] = 'Could not find that user'
    end
    redirect_to :root and return
  end

  def new_caregiver
    @users = User.regular
  end

  def create_caregiver

  end

  private

  def user_params
    params.require(:user).permit(:email, :phone_number, :first_name, :last_name, :password)
  end

end
