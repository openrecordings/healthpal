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
    filepath =  "#{Rails.root}/tmp/foo.json"
    File.open(filepath, 'wb') do |disk_file|
      disk_file.write(@recording.annotation_json)
    end
    if(@recording && current_user.can_access(@recording))
      @title = "#{@recording.user.full_name}, #{@recording.created_at.strftime('%-m/%-d/%-y')}"
      @provider = UserField.find_by(recording: @recording, type: :provider) || UserField.new(recording: @recording, type: :provider)
      @note = UserField.find_by(recording: @recording, type: :note) || UserField.new(recording: @recording, type: :note)
      @view_id = (current_user.privileged? || current_user.can_view_tags) ? 'audio-view' : 'audio-view-hide-tags'
      @segments = prepare_segments(@recording)
      @grouped_annotations = grouped_annotations(@recording)
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
        segment.tmp_annotations = segment.annotations
        segment.tmp_text = segment.text
        if multi_segment.nil?
          multi_segment = segment
        else
          if segment.tmp_annotation_categories == multi_segment.tmp_annotation_categories
            multi_segment.tmp_text += " #{segment.tmp_text}"
            multi_segment.tmp_annotations += segment.tmp_annotations
            multi_segment.end_time = segment.end_time
          else 
            return_segments << multi_segment unless multi_segment.nil?
            multi_segment = segment
          end
        end
      end
    end
    return_segments << multi_segment unless multi_segment.nil?
    return_segments
  end

  def grouped_annotations(recording)
    groups_with_annotations = []
    groups_without_annotations = []
    annotations = recording.annotations
    TagType.all.order(:label).each do |tag_type|
      annotations_for_type = annotations.select{|a| a.category == tag_type.label}.uniq {|a| a.text.titleize}.sort_by {|a| a.text.titleize}
      if annotations_for_type.any?
        groups_with_annotations << {tag_type => annotations_for_type}
      else
        groups_without_annotations << {tag_type => annotations_for_type}
      end
    end
    groups_with_annotations = groups_with_annotations.sort_by { |tag_type_hash| tag_type_hash.keys.first.label}
    groups_without_annotations = groups_without_annotations.sort_by { |tag_type_hash| tag_type_hash.keys.first.label}
    groups_with_annotations + groups_without_annotations
  end

end
