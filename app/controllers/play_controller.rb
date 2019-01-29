class PlayController < ApplicationController

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
    if (@recording && current_user.can_access(@recording))
      @utterances = []
      @recording.json.each {|utterance_hash| @utterances << Utterance.new(utterance_hash)}
    else
      flash.alert = 'An error ocurred while retriving the audio data. Please contact support.'
      redirect_to :root and return
    end
  end

  def send_audio
    recording  = Recording.find_by(id: params[:id])
    if(recording && current_user.can_access(recording))
      # Recording exists and user has access
      audio_data = File.read(recording.local_file_name_with_path)
      response.header['Accept-Ranges'] = 'bytes'
      response.headers['Content-Length'] = File.size tmp_file
      send_data(audio_data, filename: 'audio_data')
    else
      flash.alert = 'An error ocurred while retriving the audio data'
      redirect_to :root and return
    end
  end

  private

end
