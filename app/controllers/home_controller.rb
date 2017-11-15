class HomeController < ApplicationController

  def index
    redirect_to :recordings if current_user.privileged?
  end

end
