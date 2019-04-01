class InvitationsController < Devise::InvitationsController

	# Raw Devise method extnded to handle SMS verification
  def update
    puts '###################################################'
    puts params
    puts '###################################################'
    raw_invitation_token = update_resource_params[:invitation_token]
    self.resource = accept_resource
    invitation_accepted = resource.errors.empty?

    yield resource if block_given?

    if invitation_accepted
      if resource.allow_insecure_sign_in_after_accept
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message :notice, flash_message if is_flashing_format?
        sign_in(resource_name, resource)
        respond_with resource, location: after_accept_path_for(resource)
      else
        set_flash_message :notice, :updated_not_active if is_flashing_format?
        respond_with resource, location: new_session_path(resource_name)
      end
    else
			if resource.errors.any?
				if flash[:notice]
					flash.now[:notice] += resource.errors.full_messages.join('<br>'.html_safe)
				else
					flash.now[:notice] = resource.errors.full_messages.join('<br>'.html_safe)
				end
			end
      resource.invitation_token = raw_invitation_token
      respond_with_navigational(resource) { render :edit }
    end
  end

end
