class HomeController < ApplicationController

  def index
    # TODO: Temporarily starting on recordings page until we have a real landing page
    redirect_to (current_user&.privileged? ? :recordings : :my_recordings)
  end

end
