class RecordingsController < ApplicationController
  before_action :only_admins, except: [:get_metadata, :update_metadata]

  def index
    @recordings = Recording.includes(:user)
  end

  # AJAX GET a recording's metadata
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

  #AJAX POST an update to a recording's metadata
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

  #AJAX GET a recording's notes
  def get_notes
    recording = fetch_recording(params[:id])
    if recording
      render json: {
        data: recording.notes,
        status: 200
      }
    end
  end

  #AJAX POST create or update a RecordingNote
  def upsert_note
    recording = fetch_recording(params[:id])
    if recording
      recording_note = Recording.note.find_by(params[:note_id])
      if recording_note
        recording_note.update(text: params[:text])
        render json: {status: 200}
      else
        recording_note.create(recording: recording, text: params[:text])
        render json: {status: 200}
      end
    end
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
