class InvitationsController < Devise::InvitationsController

  layout 'application'

  # Raw Devise method extnded to handle SMS verification
  def update
    raw_invitation_token = update_resource_params[:invitation_token]

    # Confirm SMS token
    self.resource = resource_class.find_by_invitation_token(raw_invitation_token, true)
    phone_token_input = params[:user][:phone_token]
    if (phone_token_input == resource.phone_token) || !resource.requires_phone_confirmation
      resource.phone_confirmed_at = Time.now
      resource.save
    else
      flash.now[:notice] = 'Confirmation code incorrect'
      resource.invitation_token = raw_invitation_token
      respond_with_navigational(resource) { render :edit }
      return
    end

    # Set name fields for new users who don't yet have them
    self.resource.update(first_name: params[:user][:first_name]) if params[:user][:first_name]
    self.resource.update(last_name: params[:user][:last_name]) if params[:user][:last_name]

    # Proceed with invitation acceptance logic
    self.resource = accept_resource
    invitation_accepted = resource.errors.empty?
    yield resource if block_given?
    if invitation_accepted
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message :notice, flash_message if is_flashing_format?
      sign_in(resource_name, resource)
      respond_with resource, location: after_accept_path_for(resource)
    else
      if resource.errors.any?
        flash.now[:notice] = resource.errors.full_messages.join('<br>'.html_safe)
      end
      resource.invitation_token = raw_invitation_token
      respond_with_navigational(resource) { render :edit }
    end
  end

  def test_invitation
    self.resource = resource_class.new
    render :test_invitation
    puts "#{self.resource} HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
  end

  def post_test_invitation
    puts "HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!2\n"
    # raw_invitation_token = update_resource_params[:invitation_token]
    params_phone_number = params[:user][:phone_number]
    params_email = params[:user][:email]
    invitation_method = params[:invitation_method]

    if (invitation_method == "Email")
      self.resource = invite_resource
    else
      self.resource = invite_resource2
    end
    
    resource_invited = resource.errors.empty?

    yield resource if block_given?

    if resource_invited
      redirect_to :root
    else
      puts "INVITE FAILED!!!!!!!!!!!!!!!!"
    end
  end

  def invite_resource2
    my_resource = resource_class.invite2!(invite_params, current_inviter)
    test_url = accept_invitation_url(my_resource, invitation_token: my_resource.raw_invitation_token)
    my_resource
  end


end
