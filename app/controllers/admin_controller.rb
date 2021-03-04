class AdminController < ApplicationController
  before_action :verify_privileged

  def index; end

  def users; end

  def manage_recordings
    # Redirecting to root for R56 to close this as a security risk
    redirect_to :root

    # @recordings = Recording.all.order('created_at desc')
  end

  def create_tag; end

  def toggle_active
    user = User.find(params[:id])
    user.toggle_active
    redirect_to :admin
  end

  def toggle_can_record
    user = User.find(params[:id])
    user.toggle_can_record
    redirect_to :admin
  end

  def toggle_otp
    user = User.find(params[:id])
    user.toggle_otp
    redirect_to :admin
  end

  def new_org; end

  def create_org
    @org = Org.new(org_params)

    if @org.save
      flash.notice = "Organization #{@org.name} has been created"
      redirect_to :root
    else
      flash.alert = @org.errors.full_messages
      redirect_to new_org_path
    end
  end

  # AJAX POST to update contact_email_address
  def update_contact_email_address
    org = Org.find_by(id: params[:id])
    if org
      org.update(
        contact_email_address: params[:contact_email_address]
      )
      render json: { status: 200 }
    end
  end

  # Start the workflow for doing an in-clinic user registration
  def new_registration
    # Creating a new user to hold params, but we're only going to set the email now
    @user = User.new
    @orgs = Org.all
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
      # Only root can choose an org for a new account
      org_id: current_user.root? ? user_params[:org_id] : current_user.org.id,
      phone_number: user_params[:phone_number],
      password: user_params[:password],
      timezone: user_params[:timezone],
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

  # Select an existing user to switch to
  def switch_user_select
    @users = current_user.viewable_users.select { |u| u != current_user }
  end

  def switch_to_user
    user = User.find_by(id: params[:user_id])
    if user
      reset_session
      sign_in user
      redirect_to :root
    else
      flash.now[:alert] = 'Could not find that user'
    end
  end

  def new_caregiver
    @users = current_user.viewable_users.select { |u| u != current_user }
  end

  def create_caregiver
    @user = User.new(
      email: params['email'],
      role: 'user',
      active: true,
      org_id: User.find_by(id: params['sharer_id']).org.id,
      first_name: params['first_name'],
      last_name: params['last_name'],
      phone_number: params['phone_number'],
      created_as_caregiver: true,
      requires_phone_confirmation: false,
      can_record: false
    )
    @user.save
    @user.invite!
    @user.send_sms_token
    Share.create(
      user_id: params['sharer_id'],
      shared_with_user_id: @user.id
    )
    flash.alert = 'Caregiver account created'
    redirect_to :root
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :phone_number,
      :first_name,
      :last_name,
      :password,
      :password_2,
      :sharer_id,
      :timezone,
      :org_id
    )
  end

  def org_params
    params.require(:org).permit(
      :name,
      :contact_email_address
    )
  end
end
