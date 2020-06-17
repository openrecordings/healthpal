class RecordingsController < ApplicationController
  before_action :only_admins, except: [:get_metadata, :update_metadata]

  def index
    @recordings = Recording.includes(:user)
  end

  # AJAX GET
  def get_metadata
    recording = Recording.find_by(id: params[:id])
    if recording && current_user.viewable_recordings.include?(recording)
      render json: {
        url: helpers.url_for(recording.media_file),
        title: recording.title,
        provider: recording.provider,
        date: helpers.minimal_date(recording.created_at),
        days_ago: helpers.days_ago(recording.created_at),
        notes: recording.recording_notes,
        status: 200
      }
    else
      render json: {
        error: 'Current user does not have permission to access that recording',
        status: 401
      }
    end
  end

  #AJAX POST
  def update_metadata
    recording = Recording.find_by(id: params[:id])
    if recording && current_user.viewable_recordings.include?(recording)
      recording.update(
        title: params[:title],
        provider: params[:provider]
      )
      render json: {status: 200}
    else
      render json: {
        error: 'Current user does not have permission to access that recording',
        status: 401
      }
    end
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
    params.require(:recording).permit(:provider, :patient_identifier, :note)
  end

end
