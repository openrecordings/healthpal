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

    def create_recording!(blob, user)
      @recording = Recording.create!(user: user, filetype: 'ogg', audio: blob)
    end

    respond_to do |format|

      format.js do
        blob = params['data'].tempfile.read
        if create_recording!(blob, current_user)
          render json: nil, status: :ok
        else
          render json: @ecording.errors.to_json, status: :unproccessable_entity
        end
      end

      format.html do
        blob = file_upload_params[:file].tempfile.read
        if create_recording!(blob, User.find(file_upload_params[:user]))
          flash.notice = "Recording successfully uploaded for #{@recording.user.email}"
          redirect_to :recordings
        else
          flash.alert = @recording.errors.full_messages
          render :file_upload
        end
      end

    end
  end

  def saved
    flash.alert = 'Recording saved.'
    redirect_to my_recordings_path
  end

  private

  def file_upload_params
    params.require(:recording).permit(:file, :user)
  end
end
