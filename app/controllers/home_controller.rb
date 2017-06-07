class HomeController < ApplicationController

  def index
    redirect_to :admin if current_user.privileged?
  end

  def upload
    render json: 'success' 
  end

end
