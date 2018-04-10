class RecordingsController < ApplicationController
  before_action :only_admins, except: :update

  def index
    @recordings = Recording.includes(:user)
  end

  # Ajax endpoint for in-place editing of recordings
  def update
    #TODO: Authorization for this recording for non-privileged users
    recording = Recording.find_by(id: params[:id])
    if (recording && recording.update(recording_params))
      head :no_content
    else
      render json: recording&.errors, status: :unproccessable_entity
    end
  end

  private
  
  def recording_params
    params.require(:recording).permit(:provider, :patient_identifier)
  end

end
