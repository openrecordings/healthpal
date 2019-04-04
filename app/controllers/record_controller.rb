class RecordController < ApplicationController

  # Stub reminder that the view exists
  def new
  end

  # View for manually uploading an existing file
  def file_upload
    @recording = Recording.new
    @users = User.regular.map {|u| [u.email, u.id]}
  end

  # HTML endpoint for uploading recording files
  # AJAX endpoint for uploading new recordings
  def upload
    respond_to do |format|

      format.js do
        puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1!!!!!!!!!!'
        File.open('/Users/will/Desktop/foo.ogg', 'wb') do |file|
          file.write(request.body.read)
        end

        # TODO
        #
        # flash.alert = 'Recording saved.'
        # redirect_to my_recordings_path(current_user.id)
      end

      format.html do
        # TODO Restrict to supported mime types
        # Initialize new Recording record
        file = recording_params[:file]
        blob = file.read
        recording = Recording.new(
          user: User.find_by(id: recording_params[:user]),
          original_file_name: file.original_filename,
          file_name: "#{Digest::SHA1.hexdigest(blob)}.flac"
        )  

        # Write file to disk.
        # TODO:
        #   Encrypt
        begin
          audio_file_path = "#{Rails.root}/app/assets/audios"
          File.open(recording.media_path, 'wb') do |disk_file|
            disk_file.write(blob)
          end
        rescue File => error
          recording.errors.add(:base, "An error occured during uploading: #{error}")
        end

        if recording.save!
          recording.upload
          # recording.transcribe
          flash.notice = "Recording successfully uploaded for #{recording.user.email}"
          redirect_to :recordings
        else
          flash.alert = recording.errors.full_messages
          render :file_upload
        end
      end
    end
  end

  private

  def recording_params
    params.require(:recording).permit(:file, :user)
  end
end
