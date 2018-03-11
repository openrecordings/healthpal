class PlayController < ApplicationController

  def index

    # TODO Handle bad data
    @user = User.find params[:id]

    # TODO Resrtict this to authorized viewers when the data model is done
    @visible_users = User.where role: :user

    @recordings = @user.recordings

  end

  def play
    if (@recording = Recording.find_by(id: params[:id]))

      ##################################################################################
      # TODO Re-enable this critical security feature when caregiver data model is done.
      #      (wrapping conditional goes away)
      ##################################################################################
      if false

        unless @recording.user == current_user || current_user.privileged?
          flash.alert = 'You do not have permission to play that recording'
          redirect_to :root and return
        end

      end
      ##################################################################################

    else
      flash.alert = 'Could not find that recording'
      redirect_to :root and return
    end

    # Collapse consecutive utterances with identical tags, adjusting start-end times to cover all
    @tags = ((@recording.tags.group_by(&:utterance).inject([]) {
      |x, y| (x.empty? || (get_tags(x[-1]) != get_tags(y))) ?
        x << y :
        x[0..-2] << combine_utterances(x[-1], y)
    }).sort_by {|x| x[0].index})
  end

  def send_audio
    if (recording  = Recording.find_by(id: params[:id]))
      ##################################################################################
      # TODO Re-enable the commented-out condictional authorizing playback when the 
      #      caregiver data model is done.
      ##################################################################################
      #if recording.user == current_user || current_user.privileged?
        tmp_file = "#{Rails.root}/recordings_tmp/#{recording.id}.ogg"
        File.open(tmp_file, 'wb') { |file| file.write(recording.audio) }
        response.header['Accept-Ranges'] = 'bytes'
        response.headers['Content-Length'] = File.size tmp_file
        send_file(tmp_file)
      # else
      #   # User does not own recording and is not privileged
      #   return nil
      # end
      ##################################################################################
    else
      # Could not find recording with given id
      return nil
    end
  end

  private

  # Get the sorted list of tags for this utterance entry
  def get_tags(utterance)
    utterance[1].map(&:tag_type).sort
  end

  # Reduce two identically tagged utterance entries into a single entry which spans both of them.
  def combine_utterances(utt1, utt2)
    [Utterance.new({begins_at: utt1[0].begins_at,
                    ends_at: utt2[0].ends_at,
                    index: utt1[0].index}), utt2[1]]
  end



end
