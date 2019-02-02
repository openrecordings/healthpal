class PlayController < ApplicationController

  # Data structure for ephemeral utterance objects
  Utterance = Struct.new(:utterance_hash) do
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

  # TODO: This approach to streaming audio is not secure. Even though we create and delete a tmp
  #       file right away, that tmp file is public, potentially for a number of seconds, or longer
  #
  #       DO NOT USE PHI with this app until securely streaming audio with the NGINX secure_link
  #       module.
  ################################################################################################
  ################################################################################################
  def play
    @recording = Recording.find_by(id: params[:id])
    if(@recording && current_user.can_access(@recording))
      tmp_file_path = "#{Rails.root}/app/assets/audios/"
      FileUtils.cp(@recording.local_file_name_with_path, "#{tmp_file_path}/tmp_#{@recording.file_name}")
      @utterances = []
      @recording.json.each do |utterance_hash|
        @utterances << {
         start_time: start_time(utterance_hash),
         end_time: end_time(utterance_hash),
         text: text(utterance_hash)
        }
      end
    else
      flash.alert = 'An error ocurred while retriving the audio data. Please contact support.'
      redirect_to :root and return
    end
  end

  # AJAX POST to rm tmp file as soon as it is loaded
  def rm_tmp_file
    # recording = Recording.find_by(id: params[:id])
    # if(recording)
    #   FileUtils.rm(recording.tmp_file_name_with_path)
    # else
    #   flash.alert = 'An error ocurred while retriving the audio data. Please contact support.'
    #   redirect_to :root and return
    # end
  end
  ################################################################################################
  ################################################################################################

  private

  def start_time(utterance_hash)
    first_word = utterance_hash['alternatives'][0]['words'].first
    start_time = first_word['start_time']
    start_time['seconds'].to_f + start_time['nanos'] / 10**8
  end

  def end_time(utterance_hash)
    last_word = utterance_hash['alternatives'][0]['words'].last
    end_time = last_word['end_time']
    end_time['seconds'].to_f + end_time['nanos'] / 10**8
  end

  def text(utterance_hash)
    utterance_hash['alternatives'][0]['transcript']
  end

end
