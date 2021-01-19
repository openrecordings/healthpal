class ClicksController < ApplicationController

  # AJAX endpoint for creating a Cick record
  # One or both of user_id, recording_id may be null depending on the click context
  def create
    Click.create(
      user_id: current_user&.id,
      recording_id: params[:recording_id]&.to_i,
      element_id: params[:element_id],
      client_ip_address: request.remote_ip,
      url_when_clicked: params[:url_when_clicked],
    )
  end

end
