class PlayController < ApplicationController

  def index
    @recordings = current_user.recordings
  end

  def play
    @transcript = Transcript.find_by({recording_id: params[:id]})
    @tags = @transcript.tags.group_by(&:utterance)
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
      if recording.user = current_user || current_user.privileged?
        tmp_file = "#{Rails.root}/recordings_tmp/#{recording.id}.ogg"
        File.open(tmp_file, 'wb') { |file| file.write(recording.audio) }
        response.header['Accept-Ranges'] = 'bytes'
        send_file(tmp_file)
      else
        # User does not own recording and is not privileged
        return nil
      end
    else
      # Could not find recording with given id
      return nil
    end
  end

end
