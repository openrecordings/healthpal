class PlayController < ApplicationController

  layout 'player', only: :play  

  # Data structure for ephemeral utterance objects
  Utterance = Struct.new(:utterance_hash) do
    def start_time_sec
      first_word = utterance_hash['words'].first
      first_word['start_time']['seconds'] + first_word['start_time']['nano'].to_f / 10**8 
    end

    def end_time_sec
      last_word = utterance_hash['words'].last
      last_word['start_time']['seconds'] + last_word['end_time']['nano'].to_f / 10**8 
    end
  end

  # json.first['alternatives'].first['words'].first['start_time']['seconds']
  def index
    # TODO: Handle bad data
    # TODO: Restrict admin users again?
    if current_user.privileged?
      @users = User.joins(:recordings).order(:email).uniq
    else
      # All users who are currently sharing with current_user
      @users = [current_user] + Share.shared_with_user(current_user).map {|s| s.user}.
        sort_by {|s| s.last_name}
    end
  end

  def play
    @recording = Recording.find_by(id: params[:id])
    if @recording
      if current_user.can_access(@recording)
        @utterances = []
        @recording.json.each {|utterance_hash| @utterances << Utterance.new(utterance_hash)}
      else
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

end
