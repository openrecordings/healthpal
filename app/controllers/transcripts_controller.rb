class TranscriptsController < ApplicationController

  def index
  end

  def new
    @transcript = Transcript.new source: :acusis
  end

  def create
    @transcript = Transcript.new(transcript_params)
    # As it comes in from the form, raw is an UploadedFile object
    # We only want the ascii text, so convert the file object to ascii
    @transcript.process_upload
    if @transcript.save
      flash.notice = 'Transcript uploaded successfully'
      redirect_to :root
    else
      flash.alert =  @transcript.errors.full_messages
      render :new
    end
  end

  private

  def transcript_params
    params.require(:transcript).permit(:source, :recording_id, :file)
  end

end
