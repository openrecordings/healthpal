class RecordingsController < ApplicationController
  before_action :only_admins, except: [:get_metadata, :update_metadata]

  def index
    @recordings = Recording.includes(:user)
  end

  # AJAX GET
  def get_metadata
    recording = fetch_recording(params[:id])
    if recording
      render json: {
        url: helpers.url_for(recording.media_file),
        title: recording.title,
        provider: recording.provider,
        date: helpers.minimal_date(recording.created_at),
        days_ago: helpers.days_ago(recording.created_at),
        notes: recording.recording_notes,
        status: 200
      }
    end
  end

  #AJAX POST
  def update_metadata
    recording = fetch_recording(params[:id])
    if recording
      recording.update(
        title: params[:title],
        provider: params[:provider]
      )
      render json: {status: 200}
    end
  end

  #AJAX GET
  def get_notes
  end

  private
  
  def recording_params
    params.require(:recording).permit(:provider, :patient_identifier, :note)
  end

  def fetch_recording(id)
    recording = Recording.find_by(id: params[:id])
    if recording && current_user.viewable_recordings.include?(recording)
      return recording
    else
      render json: {
        error: 'Current user does not have permission to access that recording',
        status: 401
      } and return nil
    end
  end

end
