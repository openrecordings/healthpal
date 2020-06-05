class PlayController < ApplicationController
  # A reminder for parsing (some generation of) transcript JSON from AWS
  # json.first['alternatives'].first['words'].first['start_time']['seconds']

  # TODO: Handle non-user roles
  #       Handle non-existant recording ids
  #       Handle non-existant media files
  # Has two forms, with and without an intial recording ID on page load:
  #   - HTML request without a recording ID: /my_recordings (@recording will be nil)
  #   - HTML request with a recording ID: /my_recordings/45
  def index
    @recording = Recording.find_by(id: params[:id])
    @recordings = current_user.viewable_recordings
  end

  def video_url
    recording = Recording.find_by(id: params[:id])
    if recording && current_user.viewable_recordings.include?(recording)
      render json: {
        url: helpers.url_for(recording.media_file),
        status: 200
      }
    else
      render json: {
        error: 'Current user does not have permission to access that recording',
        status: 401
      }
    end
  end

  # TODO: Make this AJAX and add the needed data to the video method
  # def play
  #   @recording = Recording.find_by(id: params[:id])
  #   if(@recording && current_user.can_access(@recording))
  #     @title = "#{@recording.user.full_name}, #{@recording.created_at.strftime('%-m/%-d/%-y')}"
  #     @provider = UserField.find_by(recording: @recording, type: :provider) || UserField.new(recording: @recording, type: :provider)
  #     @note = UserField.find_by(recording: @recording, type: :note) || UserField.new(recording: @recording, type: :note)
  #     @utterances = prepare_utterances(@recording)
  #     @view_id = @recording.is_video ? 'video-view' : (!!ENV['HIDE_TAGS'] ? 'audio-view-hide-tags' : 'audio-view')
  #   else
  #     flash.alert = 'An error ocurred while retriving the audio data. Please contact support.'
  #     redirect_to :root and return
  #   end
  # end

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

  # Merges contiguous utterances that have the same tag(s)
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
