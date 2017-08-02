class PlayController < ApplicationController

  def index
    @recordings = current_user.recordings
  end

  def play
    if (@recording = Recording.find_by(id: params[:id]))
      unless @recording.user = current_user || current_user.privileged?
        flash.alert = 'You do not have permission to play that recording'
        redirect_to :root and return
      end
    else
      flash.alert = 'Could not find that recording'
      redirect_to :root and return
    end
  end

  def send_audio
    tmp_file = '/tmp/tmp.ogg'
    File.open(tmp_file, 'wb') { |file| file.write(Recording.last.audio) }
    send_file(tmp_file)
  end

end
