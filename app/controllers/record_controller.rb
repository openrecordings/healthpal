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
        # blob = params['data'].tempfile.read
        # if create_recording!(blob, current_user)
        #   render json: nil, status: :ok
        # else
        #   render json: @ecording.errors.to_json, status: :unproccessable_entity
        # end
      end

      format.html do
        # @recording = Recording.create!(user: user, filetype: 'flac', audio_file:)
			  recording = Recording.new(
          user: recording_params[:user],
          file_name: recording_params[:file].original_filename
        )	
        if recording.create!
          flash.notice = "Recording successfully uploaded for #{recording.user.email}"
          redirect_to :recordings
        else
          flash.alert = recording.errors.full_messages
          render :file_upload
        end
      end

     
# def upload
#   uploaded_io = params[:person][:picture]
#   File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
#     file.write(uploaded_io.read)
#   end
# end 

    end
  end

  def saved
    flash.alert = 'Recording saved.'
    redirect_to my_recordings_path(current_user.id)
  end

  private

  def file_upload_params
    params.require(:recording).permit(:file, :user)
  end
end
