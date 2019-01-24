class RecordController < ApplicationController

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
        # TODO
        #
        # flash.alert = 'Recording saved.'
        # redirect_to my_recordings_path(current_user.id)
      end

      format.html do
        # TODO Restrict to supported mime types
        # Initialize new Recording record
        file = recording_params[:file]
        recording = Recording.new(
          user: User.find_by(id: recording_params[:user]),
          file_name: file.original_filename,
          file_hash: Digest::SHA1.hexdigest(file.read)
        )  

        # Write file to disk. TODO: encrypt!
        begin
          File.open(recording.local_file_name_with_path), 'wb') do |disk_file|
            disk_file.write(file.read)
          end
        rescue File => error
          recording.errors.add(:base, "An error occured during uploading: #{error}")
        end

        if recording.save!
          recording.upload
          recording.transcribe
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
