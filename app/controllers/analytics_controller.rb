class AnalyticsController < ApplicationController

  before_action :verify_privileged

  # A view for [Visit] records from [Ahoy] - deprecated. Ahoy is buggy
  # @deprecated
  def index
    @visits_for_select = current_user.viewable_visits.sort_by{ |v| v.started_at }.map{|v| ["#{v.user&.email} #{helpers.format_date_time(v.started_at)}", v.id] }
    @visit = Ahoy::Visit.find(params[:id]) if params[:id]
  end

end
