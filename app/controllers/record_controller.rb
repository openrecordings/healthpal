class RecordController < ApplicationController

  # In-app recordings, coming in as AJAX
  def upload
    handle_blob(request.body.read, current_user)
  end

  # View for manually uploading an existing file
  def file_upload
    @recording = Recording.new
    @users = User.regular.map {|u| [u.email, u.id]}
  end

  # Admin-uploaded recordings
  def upload_file
    handle_blob(recording_params[:file].read, User.find_by(id: recording_params[:user]), true)
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

  def create_utterances
    recording = Recording.find(params[:recording_id])
    recording.transcript_txt_file = params[:file]
    recording.build_utterances
    redirect_to :admin
  end

  private

  def handle_blob(blob, user, is_file_upload=false)
    sha1 = Digest::SHA1.hexdigest(blob)
    filepath =  "#{Rails.root}/tmp/#{sha1}.ogg"
    File.open(filepath, 'wb') do |disk_file|
      disk_file.write(blob)
    end
    recording = Recording.new(
      user: user,
      sha1: sha1,
      is_video: false,
      media_format: 'mp3',
    )
    recording.media_file.attach(io: File.open(filepath), filename: "#{sha1}.ogg")
    `rm #{filepath}`  
    if recording.save!
      recording.transcribe
      flash.alert = 'Your recording is being processed. We will email you when it is ready.'
    else
      flash.alert = recording.errors.full_messages
    end
    flash.keep(:alert)
    if is_file_upload
      redirect_to :recordings
    else
      render js: "window.location = '#{my_recordings_path(current_user.id)}'"
    end
  end

  def recording_params
    params.require(:recording).permit(:file, :user)
  end

  def transcript_params
    params.permit(:recording_id, :file)
  end

end
