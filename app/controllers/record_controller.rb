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
  def upload
    blob = request.body.read
    new_recording_params = {user: current_user, file_name: "#{Digest::SHA1.hexdigest(blob)}.mp3"}
    recording = recording_from_blob(blob, new_recording_params)
    if recording.save!

      # TODO Re-enable once asynchronous
      # process_recording(recording)

      flash.alert = 'Recording successfully saved.'
    else
      flash.alert = recording.errors.full_messages
    end
    flash.keep(:alert)
    render js: "window.location = '#{my_recordings_path(current_user.id)}'"
  end

  # Create a recording by uploading an existing file
  def upload_file
    # TODO Restrict to supported mime types
    file = recording_params[:file]
    blob = file.read
    new_recording_params = {
      user: User.find_by(id: recording_params[:user]),
      file_name: "#{Digest::SHA1.hexdigest(blob)}.mp3",
      original_file_name: file.original_filename,
    }
    recording = recording_from_blob(blob, new_recording_params)
    if recording.save!
      process_recording(recording)
      redirect_to :recordings
    else
      flash.alert = recording.errors.full_messages
      render :file_upload
    end
  end

  private

  def recording_params
    params.require(:recording).permit(:file, :user)
  end

  def recording_from_blob(blob, new_recording_params)
    return unless new_recording_params[:file_name]
    recording = Recording.new(new_recording_params)
    begin
      File.open(recording.ogg_path, 'wb') do |disk_file|
        disk_file.write(blob)
      end
    rescue File => error
      recording.errors.add(:base, "An error occured during saving: #{error}")
    end
    # Convert from OGG to MP3
    `ffmpeg -i #{recording.ogg_path} #{recording.media_path}`
    recording
  end

  def process_recording(recording)
    recording.upload
    recording.transcribe
  end

end
