class TagsController < ApplicationController

  def create
    tag = Tag.new(
      utterance: Utterance.find_by(id: tag_params[:utterance_id]),
      tag_type: TagType.find_by(id: tag_params[:tag_type_id])
    )
    unless(tag.save)
      flash.alert = tag.errors.full_messages
    end
    redirect_to action: :new, id: tag.utterance.recording.id, utterance_id: tag.utterance.id
  end

  def new
    @recording = Recording.find(params[:id])
    @utterance = Utterance.find_by(id: params[:utterance_id]) || @recording.utterances.first
  end

  def destroy_for_utterance
    utterance = Utterance.find_by(id: params[:id])
    utterance.tags.each{|t| t.destroy}
    redirect_to action: :new, id: utterance.recording.id, utterance_id: utterance.id
  end

  private

  def tag_params
    params.require(:tag).permit(:utterance_id, :tag_type_id)
  end

end
