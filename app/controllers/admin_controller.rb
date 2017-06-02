class AdminController < ApplicationController

  def index
  end

  def users
  end

  def toggle_otp
    user = User.find(params[:id])
    user.toggle_otp
    redirect_to :admin
  end

end
