class TranscriptsController < ApplicationController

  before_action :only_admins

  def index
  end

  def new
    @recording = Recording.find(params[:recording_id])
    @transcript = Transcript.new source: :acusis
  end

  def create
    @transcript = Transcript.new(transcript_params)
    @transcript.recording = Recording.find(params[:recording_id])
    # As it comes in from the form, raw is an UploadedFile object
    # We only want the ascii text, so convert the file object to ascii
    @transcript.process_upload
    if @transcript.save
      flash.notice = 'Transcript uploaded successfully'
      redirect_to recordings_path
    else
      flash.alert =  @transcript.errors.full_messages
      render :new
    end
  end

  def edit
    @transcript = Transcript.find_by({recording_id: params[:id]})
    @tagTypes = TagType.all
    @tags = @transcript.tags.select("tag_type_id, utterance_id").group_by(&:utterance_id)
  rescue
    flash.now.alert = 'Could not find a transcript with that ID'
    redirect_to :root
  end

  private

  def transcript_params
    params.require(:transcript).permit(:source, :file)
  end

end
