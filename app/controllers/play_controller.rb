class PlayController < ApplicationController

  def index
    # TODO: Handle bad data
    # TODO: Restrict admin users again?
    
    # TODO: Delete temp conditional
    # if current_user.privileged?
    if current_user.privileged? && current_user.email != 'ma.admin@audiohealthpal.com'

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
      @provider = UserField.find_by(recording: @recording, type: :provider) || UserField.new(recording: @recording, type: :provider)
      @note = UserField.find_by(recording: @recording, type: :note) || UserField.new(recording: @recording, type: :note)
      @view_id = 'audio-view'
      @segments = prepare_segments(@recording)
    else
      flash.alert = 'An error ocurred while retriving the audio data. Please contact support.'
      redirect_to :root and return
    end
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

  # Merges contiguous TranscriptSegments that have the same Annotation categories
  def prepare_segments(recording)
    return_segments = []
    multi_segment = nil
    segments = recording.transcript_segments
    recording.transcript_segments.each do |segment|
      if segment.annotations.any?
        segment.tmp_annotation_categories = segment.annotation_categories
        if multi_segment.nil?
          multi_segment = segment
          segment.tmp_text = segment.text
        end
        if segment.tmp_annotation_categories == multi_segment.tmp_annotation_categories
          multi_segment.tmp_text += " #{segment.text}"
          multi_segment.end_time = segment.end_time
          # multi_segment.links += segment.links
        else 
          return_segments << multi_segment unless multi_segment.nil?
          multi_segment = segment
          segment.tmp_text = segment.text
        end
      end
    end
    return_segments << multi_segment unless multi_segment.nil?
  end
  return_segments
end
