class HomeController < ApplicationController

  def index
    redirect_to :admin if current_user.privileged?
  end

  def upload
    blob = params['data'].tempfile.read
    render json: nil, status: :ok
  end

end
