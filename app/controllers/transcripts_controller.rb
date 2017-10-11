class TranscriptsController < ApplicationController

  def index
  end

  def new
    @transcript = Transcript.new format: :acusis
  end

  def create
    file_to_text
    @transcript = Transcript.new(transcript_params)
    # TODO: convert raw to actual tempfile contents
    @transcript.raw_to_ascii 
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    puts transcript_params.inspect
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    render :new
  end

  private

  def transcript_params
    params.require(:transcript).permit(:format, :recording_id, :raw)
  end

end
