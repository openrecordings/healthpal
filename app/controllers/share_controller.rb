class ShareController < ApplicationController

  def index
    redirect_to :no_shares unless current_user.has_active_shares? || params[:confirmed]
  end

  # If the user has no active shares, hit this view to double-check that the user knows
  # what they are getting into
  def no_shares
  end

end
