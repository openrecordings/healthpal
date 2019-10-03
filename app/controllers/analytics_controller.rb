class AnalyticsController < ApplicationController

  before_action :verify_privileged

  def index
    @visits = Ahoy::Visit.all
  end

end
