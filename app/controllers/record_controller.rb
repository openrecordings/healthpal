class RecordController < ApplicationController

  def new
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

end
