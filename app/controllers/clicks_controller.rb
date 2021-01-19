class ClicksController < ApplicationController

  # AJAX endpoint for creating a Cick record
  # One or both of user_id, recording_id may be null depending on the click context
  def create
    Click.create!(
      user_id: current_user&.id,
      recording_id: click_params[:recording_id],
      element_id: click_params[:element_id],
      client_ip_address: request.remote_ip,
      url_when_clicked: click_params[:url_when_clicked],
    )
    render json: {status: 200} 
  end

  private

  def click_params
    params.permit(
      :recording_id,
      :element_id,
      :url_when_clicked,
    )
  end

end
