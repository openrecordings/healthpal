class HomeController < ApplicationController

  def index
    redirect_to :admin if current_user.privileged?
  end

  # AJAX endpoint for uploading recordings
  def upload
    if current_user
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
    else
      render json: nil, status: :unauthorized
    end
  end

end
