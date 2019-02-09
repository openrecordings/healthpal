class PlayController < ApplicationController

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
      @utterances = prepare_utterances(@recording)
      tmp_file_path = "#{Rails.root}/app/assets/audios/"
      FileUtils.cp(@recording.local_file_name_with_path, "#{tmp_file_path}/#{@recording.tmp_file_name}")
    else
      flash.alert = 'An error ocurred while retriving the audio data. Please contact support.'
      redirect_to :root and return
    end
  end

  # AJAX GET to rm tmp file as soon as it is loaded
  def rm_tmp_file
		begin  
      recording = Recording.find_by(id: params[:id])
      tmp_file_path = "#{Rails.root}/app/assets/audios/"
      FileUtils.rm("#{tmp_file_path}/#{recording.tmp_file_name}")
      render json: 'success' and return
		rescue StandardError => error
      render json: {errors: error.message}, :status => 422
		end  
  end
  ################################################################################################
  ################################################################################################

  private

  def prepare_utterances(recording)
    return nil unless recording.utterances.any?
    tagged_utterances = []
    last_utterance = false
    recording.utterances.each do |utterance|
      if utterance.tags.any?
        # TODO: Put a time cutoff on this between one utterance ending and the next beginning
        if last_utterance && (last_utterance&.tag_types & utterance.tag_types).any?
          multi_utterance = build_multi_utterance(last_utterance, utterance) 
          tagged_utterances << multi_utterance
          last_utterance = multi_utterance
        else
          utterance.tmp_tag_types = utterance.tags.map {|t| t.tag_type}
          tagged_utterances << utterance
          last_utterance = utterance
        end
      end
    end
    tagged_utterances
  end

  def build_multi_utterance(first_utterance, second_utterance)
    multi_utterance = Utterance.new(
      recording: first_utterance.recording,
      text: "#{first_utterance.text} #{second_utterance.text}",
      begins_at: first_utterance.begins_at,
      ends_at: second_utterance.ends_at,
      tmp_tag_types: (first_utterance.tag_types + second_utterance.tag_types).uniq!
    )
    
  end

end
