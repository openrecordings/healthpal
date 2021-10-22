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

  # AJAX POST to update the Participant's REDCap ID
  def update_redcap_id
    user = User.find_by(id: params[:id])
    if user
      participant = user.participant
      if participant
        participant.update(redcap_id: params[:value])
      else
        Participant.create(
          user: user,
          org: user.org,
          redcap_id: params[:value]
        )
      end
    end
    render json: { status: 200 }
  end

  # AJAX POST to update phone_number
  def update_phone_number
    User.find_by(id: params[:id])&.update(phone_number: params[:value], sms_notifications: true)
    render json: { status: 200 }
  end

  # AJAX POST to update phone_number
  def update_followup_message
    User.find_by(id: params[:id])&.recordings&.last&.followup_message
      &.update(deliver_at: (DateTime.strptime(params[:value],
                                              '%m/%d/%Y') - 3.days).change({ hour: 15,
                                                                             min: 0,
                                                                             sec: 0 }))
    render json: { status: 200 }
  end

  # Start the workflow for doing an in-clinic user registration
  def new_registration
    # Creating a new user to hold params, but we're only going to set the email now
    @user = User.new
    @caregivers = current_user.viewable_users.select { |u| u != current_user && u.created_as_caregiver} 
    @orgs = Org.all
  end

  # Set password for in-clinic user registration
  def set_password
    @user = User.new(user_params)
    unless !params[:cg].present?
      @cg_id = params[:cg]
      if @user.org_id != User.find_by(id: @cg_id).org_id
        flash.alert = "Caregiver and patient are not in the same organization"
      end
    end
  end

  # Create new user
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
      # sign_in @user #Don't sign in for VA bc won't be using recording software
      redirect_to :root and return
    else
      flash.alert = @user.errors.full_messages
      redirect_to new_registration_path(email: @user.email)
    end

    if user_params[:cg].present?
      if @user.save
        Share.create(
          user_id: @user.id,
          shared_with_user_id: user_params[:cg]
        ) 
        redirect_to :root and return
      else
        flash.alert = @user.errors.full_messages
        redirect_to new_registration_path(email: @user.email)
      end
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
    @orgs = Org.all
  end

  def add_caregiver
    @users = current_user.viewable_users.select { |u| u != current_user }
    @caregivers = current_user.viewable_users.select { |u| u != current_user && u.created_as_caregiver} 
  end

  def create_share
    if User.find_by(id: params['sharer_id']).org_id != User.find_by(id: params['cg']).org_id
      flash.alert = 'Caregiver and patient organizations don\'t match'
      redirect_to add_caregiver_path and return
    elsif User.find_by(id: params['sharer_id']).get_caregivers.include? User.find_by(id: params['cg'])
      flash.alert = 'Already sharing with this caregiver'
      redirect_to :root
    else
      Share.create(user_id: params['sharer_id'], shared_with_user_id: params['cg'])
      flash.alert = 'Caregiver added'
      redirect_to :root
    end
  end

  def create_caregiver
    if current_user.root?
      if !params['sharer_id'].present? && !params['org_id'].present?
        flash.alert = 'Please select \'Caregiver for\' or \'Organization\' fields'
        redirect_to new_caregiver_path and return
      elsif params['sharer_id'].present? && params['org_id'].present? && User.find_by(id: params['sharer_id']).org_id.to_i != params['org_id'].to_i    
        flash.alert = 'Caregiver and patient organizations don\'t match'
        redirect_to new_caregiver_path and return
      else
        form_org_id = params['org_id'].present? ? params['org_id'].to_i : User.find_by(id: params['sharer_id']).org_id.to_i
      end
    elsif current_user.admin?
      form_org_id = current_user.org_id
    end

    @user = User.new(
      email: params['email'],
      role: 'user',
      active: true,
      org_id: form_org_id,
      first_name: params['first_name'],
      last_name: params['last_name'],
      phone_number: params['phone_number'],
      created_as_caregiver: true,
      requires_phone_confirmation: false,
      can_record: false
    )
    @user.save
    @user.invite!
    if params['sharer_id'].present?
      Share.create(
      user_id: params['sharer_id'],
      shared_with_user_id: @user.id
    )
    end
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
      :org_id,
      :cg,
    )
  end

  def org_params
    params.require(:org).permit(
      :name,
      :contact_email_address
    )
  end
end
