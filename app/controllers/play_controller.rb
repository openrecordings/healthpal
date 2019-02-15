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
    @title = "#{@recording.user.full_name}, #{@recording.created_at.strftime('%-m/%-d/%-y')}"
    @provider = UserField.find_by(user: current_user, type: :provider) || UserField.new(user: current_user, type: :provider, text_area: false)
    @note = UserField.find_by(user: current_user, type: :note) || UserField.new(user: current_user, type: :note , text_area: false)
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
  
  # TODO Handle bad params
  def user_field
    type = params['type']
    text = params['text']
    existing_field = UserField.find_by(user: current_user, type: type)
    field = existing_field || UserField.new(user: current_user, type: type)
    field.text = text
    if field.save
      render json: {result: 'success'}
    else
      render json: {result: 'nope'}
    end
  end

  private

  def prepare_utterances(recording)
    return_utterances = []
    multi_utterance = nil
    recording.utterances.order(:index).each do |utterance|
      if utterance.tags.any?
        utterance.tmp_tag_types = utterance.tag_types
        if multi_utterance.nil?
          multi_utterance = utterance
        else
          if utterance.tmp_tag_types == multi_utterance.tmp_tag_types
            multi_utterance.text += " #{utterance.text}"
            multi_utterance.ends_at = utterance.ends_at
            multi_utterance.links += utterance.links
          else 
            return_utterances << multi_utterance
            multi_utterance = utterance

          end
        end
      else
        # return_utterances << utterance
      end
    end
    return_utterances
  end

end
