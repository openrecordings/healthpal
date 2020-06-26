class RecordingsController < ApplicationController
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

  # AJAX POST an update to a recording's metadata
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

  # AJAX GET a recording's notes
  def get_notes
    recording = fetch_recording(params[:id])
    if recording
      render json: {
        notes: recording.notes,
        status: 200
      }
    end
  end

  # AJAX POST create or update a RecordingNote
  def upsert_note
    recording = fetch_recording(params[:id])
    if recording
      if params[:note_id]
        note = RecordingNote.find_by(id: params[:note_id])
      else
        note = RecordingNote.new(recording: recording) 
      end
      if note
        note.text = params[:text]
        if note.save
          render json: {status: 200}
        else
          render json: {
            error: 'Error upserting note',
            status: 500
          }
        end
      end
    end
  end

  # AJAX delete a note
  def delete_note
    recording = fetch_recording(params[:recording_id])
    if recording
      if Note.find_by(:note_id).destroy
          render json: {status: 200}
      else
          render json: {
            error: 'Error deleting note',
            status: 500
          }
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
        error: 'User does not have permission to access that recording',
        status: 401
      } and return nil
    end
  end

end
