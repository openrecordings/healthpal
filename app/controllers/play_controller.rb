class PlayController < ApplicationController

  def index
    @recordings = current_user.recordings
  end

  def play
    if (@recording = Recording.find_by(id: params[:id]))
      unless @recording.user == current_user || current_user.privileged?
        flash.alert = 'You do not have permission to play that recording'
        redirect_to :root and return
      end
    else
      flash.alert = 'Could not find that recording'
      redirect_to :root and return
    end

    # Collapse consecutive utterances with identical tags, adjusting start-end times to cover all
    @tags = ((@recording.tags.group_by(&:utterance).inject([]) {
      |x, y| (x.empty? || (x[-1][1].map(&:tag_type).sort != y[1].map(&:tag_type).sort))?
        x << y :
        x[0..-2] << [Utterance.new({begins_at: x[-1][0].begins_at, ends_at: y[0].ends_at, index: x[-1][0].index}), y[1]]
    }).sort_by {|x| x[0].index})
  end

  def send_audio
    if (recording  = Recording.find_by(id: params[:id]))
      if recording.user == current_user || current_user.privileged?
        tmp_file = "#{Rails.root}/recordings_tmp/#{recording.id}.ogg"
        File.open(tmp_file, 'wb') { |file| file.write(recording.audio) }
        response.header['Accept-Ranges'] = 'bytes'
        response.headers['Content-Length'] = recording.audio.length
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
