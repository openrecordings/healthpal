class HomeController < ApplicationController

  def index
    # TODO: Temporarily starting on recordings page until we have a real landing page
    redirect_to :my_recordings
  end

end
