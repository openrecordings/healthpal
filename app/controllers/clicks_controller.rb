class ClicksController < ApplicationController

  # AJAX endpoint for creating a Cick record
  # One or more of user, recording_id, and player_state_when_clicked may be null depending on the click context
  def create
    Click.create(
      user: current_user,
      recording_id: click_params[:recording_id],
      element_id: click_params[:element_id],
      client_ip_address: request.remote_ip,
      url_when_clicked: click_params[:url_when_clicked],
      player_state_when_clicked: click_params[:player_state_when_clicked],
      ranges_played_since_load: click_params[:ranges_played_since_load] ? click_params[:ranges_played_since_load] : nil,
    )
    render json: {status: 200} 
  end

private

  def click_params
    params.permit(
      :recording_id,
      :element_id,
      :url_when_clicked,
      :player_state_when_clicked,
      :ranges_played_since_load,
    )
  end

end
