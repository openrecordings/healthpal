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
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    user = User.find_by(id: params[:user_id])
    if user
      reset_session
      sign_in user
    else
      flash.now[:alert] = 'Could not find that user'
    end
    redirect_to :root
  end

  def new_caregiver
    @users = User.regular
  end

  def create_caregiver
    @user = User.new(
      email: params['email'],
      role: 'user',
      active: true,
      first_name: params['first_name'],
      last_name: params['last_name'],
    )
    @user.password = params['password']
    @user.save
    Share.create(
      user_id: params['sharer_id'],
      shared_with_user_id: @user.id,
    )
  end

  # AJAX endpoint for setting whether or not a recording is visible by its owner
  def set_user_can_access
    recording = Recording.find(params[:id])
    if recording.update(user_can_access: params[:make_visible] == 'true' ? true : false)
      recording.create_ready_email
      recording.send_ready_email
      flash.notice = 'Recording marked as audited. Email sent to user.'
      flash.keep(:notice)
      render json: {}
    else
      render json: {error: 'An error occured when updating recording visibility', status: 422}
    end
  end

  # AJAX endpoint for deleting an Annotation and all notations for this recording in the same category with the
  # same `text` atrribute
  def delete_annotation
    annotation = Annotation.find(params[:id])
    category = annotation.category
    text = annotation.text.titleize
    annotation.transcript_segment.recording.annotations.each{|a| a.destroy if a.category == category && a.text.titleize == text}
    flash.notice = 'Annotation deleted'
    flash.keep(:notice)
    render json: {}
  end

  # AJAX endpoint for setting medline_url for an Annotation to nil
  def delete_link
    Annotation.find(params[:id]).update(
      medline_summary: nil,
      medline_url: nil,
    )
    flash.notice = 'Link deleted'
    render json: {}
  end

  # AJAX endpoint for setting can_view_tags for a user
  def set_can_view_tags
    User.find_by(id: params[:id].to_i).update can_view_tags: params[:value] == 'true' ? true : false, can_view_tags_editable: false
    render json: {}
  end 

  # AJAX endpoint for setting can_view_tags_editable for a user
  def set_can_view_tags_editable
    User.find_by(id: params[:id].to_i).update can_view_tags_editable: params[:value] == 'true' ? true : false
    render json: {}
  end 


  private

  def user_params
    params.require(:user).permit(:email, :phone_number, :first_name, :last_name, :password, :password_2, :sharer_id)
  end

end
