class TagsController < ApplicationController

  def create
    Tag.create(
      recording_id: tag_params[:recording_id],
      tag_type_id: tag_params[:tag_type_id]
    )
    redirect_to :root
  end

  private

  def tag_params
    pararms.require(:tag).permit(:utterance_id, :tag_type_id)
  end

end
