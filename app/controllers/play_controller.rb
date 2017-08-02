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
    if (recording  = Recording.find_by(id: params[:id]))
      tmp_file = "#{Rails.root}/recordings_tmp/#{recording.id}.ogg"
      File.open(tmp_file, 'wb') { |file| file.write(recording.audio) }
      send_file(tmp_file)
    else
      # Should never get here. Audio src links are generated by play view
      return nil
    end
  end

end
