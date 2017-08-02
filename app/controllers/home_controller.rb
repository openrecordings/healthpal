class HomeController < ApplicationController

  require 'base64'

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

  def play
    # TODO: Pass in a recording ID
    @recording = Recording.last
    @audio_base_64 = Base64.encode64(@recording.audio)
  end

  def send_audio
    tmp_file = '/tmp/tmp.ogg'
    File.open(tmp_file, 'wb') { |file| file.write(Recording.last.audio) }
    send_file(tmp_file)
  end

end
