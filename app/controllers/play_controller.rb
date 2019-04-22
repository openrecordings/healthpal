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

  def play
    @recording = Recording.find_by(id: params[:id])
    if(@recording && current_user.can_access(@recording))
      @title = "#{@recording.user.full_name}, #{@recording.created_at.strftime('%-m/%-d/%-y')}"
      @provider = UserField.find_by(recording: @recording, type: :provider) || UserField.new(recording: @recording, type: :provider, text_area: false)
      @note = UserField.find_by(recording: @recording, type: :note) || UserField.new(recording: @recording, type: :note , text_area: false)
      @utterances = prepare_utterances(@recording)
    else
      flash.alert = 'An error ocurred while retriving the audio data. Please contact support.'
      redirect_to :root and return
    end
  end

  # TODO Handle bad params
  def send_media
    file_path = Recording.find(params[:id]).media_path 
    response.set_header('Cache-Control', 'public, must-revalidate, max-age=0')
    response.set_header('Accept-Ranges', 'bytes')
    response.set_header('Content-Length', File.size(file_path))
    response.set_header('Pragma', 'no-cache')
    response.set_header('Content-Transfer-Encoding', 'binary')
    send_file(file_path, disposition: 'inline')
  end
  
  # AJAX endpoint for in-place editing of UserFields
  # TODO Handle bad params
  def user_field
    recording = Recording.find_by(id: params[:id])
    type = params['type']
    text = params['text']
    existing_field = UserField.find_by(recording: recording, type: type)
    field = existing_field || UserField.new(recording: recording, type: type)
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
    utterances = recording.utterances.order(:index) 
    utterances.each do |utterance|
      if utterance.tags.any?
        utterance.tmp_tag_types = utterance.tag_types
        multi_utterance = utterance if multi_utterance.nil?
        if utterance.tmp_tag_types == multi_utterance.tmp_tag_types
          multi_utterance.text += " #{utterance.text}"
          multi_utterance.ends_at = utterance.ends_at
          multi_utterance.links += utterance.links
        else 
          return_utterances << multi_utterance unless multi_utterance.nil?
          multi_utterance = utterance
        end
        puts return_utterances.map{|u| u.id}
      end
    end
    return_utterances << multi_utterance unless multi_utterance.nil?
    return_utterances
  end

end
