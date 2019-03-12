class ShareController < ApplicationController

  def index
    @shares = current_user.shares.active
    redirect_to :no_shares unless @shares.any? || params[:confirmed]
  end

  # If the user has no active shares, hit this view to double-check that the user knows
  # what they are getting into
  def no_shares
  end

  # AJAX-only endpoint for creating a new Share record
  def create
    user = User.find_by(email: params['email'])
    if user
      new_share = Share.new(user: current_user, shared_with_user_id: user.id)
      # Prevent duplicates
      if current_user.shares.active.any? {|s| s.shared_with.email.downcase == params['email'].downcase}
        render json: {
          error: "You are already sharing your recordings with #{params['email']}",
          status: 422
        }
        return
      end
      if new_share.save 
        flash.notice = "You are now sharing all of your recordings with #{params['email']}"
        render json: {}
        return
      else
        render json: {error: new_share.errors.full_messages, status: 422}
        return
      end
    else
      if create_user_invite_and_share!(params['first_name'], params['last_name'], params['email'])
        flash.notice = "You are now sharing all of your recordings with #{params['email']}"
        render json: {}
        return
      else
        render json: {error: 'An error occured when creating the new user', status: 422}
        return
      end
    end
  end

  def destroy
    share = Share.find_by id: params['id']
    # Handle bad incoming IDs
    unless share
      render json: {error: "Could not find that sharing record. Contact and administrator."},
        status: 404
      return
    end
    share.update revoked_at: Time.now
    flash.notice = "You are no longer sharing your recordings with #{share.shared_with.email}"
    render json: {}
  end

  private

  def create_user_invite_and_share!(first_name, last_name, email)
    if user = User.create(
      first_name: first_name,
      last_name: last_name,
      password: SecureRandom.hex,
      email: email,
      active: true,
      role: 'user')
      user.invite!
      Share.create(user: current_user, shared_with_user_id: user.id)
      return true
    end
    false
  end

end
