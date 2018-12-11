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
    render json: {param: params['foo']}
  end

end
