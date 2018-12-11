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
    user = User.find_by email: params['email']
    if user
      new_share = Share.new(user: current_user, shared_with_user_id: user.id)
      # Prevent duplicates
      if current_user.shares.active.any? {|s| s.shared_with.email.downcase == params['email'].downcase}
        render json: {
          error: "It looks like you are already sharing your recordings with #{params['email']}",
          status: 422
        }
        return
      end
      if new_share.save 
        render json: {}
      else
        render json: {error: new_share.errors.full_messages, status: 422}
        return
      end
    else
      render json: {error: "Could not find an account with the email address #{params['email']}"},
        status: 404
    end
  end

end
