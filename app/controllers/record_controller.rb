class RecordController < ApplicationController

  # Stub reminder that the view exists
  def new
  end

  # View for manually uploading an existing file
  def file_upload
    @recording = Recording.new
    @users = User.regular.map {|u| [u.email, u.id]}
  end

  # In-app recordings. Come in as AJAX but redirected to my_recordings if successful.
  # TODO: Only handles audio as of now
  def upload
    blob = request.body.read
    file_name = "#{Digest::SHA1.hexdigest(blob)}.ogg"
    recording = Recording.new(
      user: current_user,
      media_format: 'mp3'
    )
    recording.media_file.attach(io: blob, filename: file_name)
    if recording.save!
      # recording.transcribe
      flash.alert = 'Your recording is being processed. We will email you when it is ready.'
    else
      flash.alert = recording.errors.full_messages
    end
    flash.keep(:alert)
    render js: "window.location = '#{my_recordings_path(current_user.id)}'"
  end

  # Create a recording by uploading an existing file
  # TODO: Broken. Needs update for new ActiveStorage approach
  def upload_file
    # TODO Restrict to supported mime types
    # file = recording_params[:file]
    # blob = file.read
    # new_recording_params = {
    #   user: User.find_by(id: recording_params[:user]),
    #   file_name: "#{Digest::SHA1.hexdigest(blob)}.mp3",
    #   original_file_name: file.original_filename,
    # }
    # recording = recording_from_blob(blob, new_recording_params)
    # if recording.save!
    #   recording.transcribe
    #   redirect_to :recordings
    # else
    #   flash.alert = recording.errors.full_messages
    #   render :file_upload
    # end
  end

  # For manually uploading a transcription from a file. Currently supports Acusis format
  def upload_transcript
    begin
      @recording = Recording.find(params[:id])
    rescue
      flash.alert = 'Recording not found.'
      redirect_to managage_recordings_path
    end
    if @recording.utterances.any?
      flash.alert = 'A transcript already exists for this recording.  If you continue, it will be deleted along with all of its tags.'
    end
  end

  # TODO Error handling
  def create_utterances
    recording = Recording.find(params[:recording_id])
    # Using attr_accessor to pass file to model instance
    recording.transcript_txt_file = transcript_params[:file]
    recording.build_utterances
    redirect_to manage_recordings_path
  end

  private

  def recording_params
    params.require(:recording).permit(:file, :user)
  end

  def transcript_params
    params.permit(:recording_id, :file)
  end

end
