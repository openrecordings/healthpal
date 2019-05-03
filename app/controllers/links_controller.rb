class LinksController < ApplicationController

  def create
    link = Link.new(
      utterance: Utterance.find_by(id: link_params[:utterance_id]),
      label: link_params[:label],
      url: link_params[:url]
    )
    unless(link.save)
      flash.alert = link.errors.full_messages
    end
    redirect_to new_tag_path(id: link.utterance.recording.id, utterance_id: link.utterance.id)
  end

  def destroy_for_utterance
    utterance = Utterance.find_by(id: params[:id])
    utterance.links.each{|l| l.destroy}
    redirect_to new_tag_path(id: utterance.recording.id, utterance_id: utterance.id)
  end

  private

  def link_params
    params.require(:link).permit(:utterance_id, :label, :url)
  end

end
