class RecordController < ApplicationController

  def new
  end

  # View for manually uploading an existing file
  def recording_upload
  end

  # AJAX endpoint for uploading recordings
  def upload
    blob = params['data'].tempfile.read
    recording = Recording.new(
      user: current_user,
      filetype: 'ogg',
      audio: blob
    )
    if recording.save
      render json: nil, status: :ok
    else
      render json: recording.errors.to_json, status: :unproccessable_entity
    end
  end

  def saved
    flash.alert = 'Recording saved.'
    redirect_to my_recordings_path
  end
end
