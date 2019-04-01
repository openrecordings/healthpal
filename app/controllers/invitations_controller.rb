class InvitationsController < Devise::InvitationsController

	# Raw Devise method extnded to handle SMS verification
  def update
    self.resource = accept_resource
    raw_invitation_token = update_resource_params[:invitation_token]

    # Confirm SMS token
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

    raw_invitation_token = update_resource_params[:invitation_token]
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

end
