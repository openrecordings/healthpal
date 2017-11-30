class UtterancesController < ApplicationController

  before_action :only_admins

  # Set (or unset if val=false) the tag (:name) for the given :utterance_id
  # Returns json of the utterance's tag_type_id's
  def set_tag
    ttype = TagType.find_by({label: params[:name]})
    utt_id = params[:utterance_id]
    if (!Utterance.find_by(id: utt_id))
      render html: 'This utterance is missing from the database.  Contact an administrator if the problem persists.' and return
    end
    if ttype
      if params[:val]
        Tag.find_or_create_by!(utterance_id: utt_id, tag_type: ttype)
      else
        Tag.where({utterance_id: utt_id, tag_type: ttype})&.destroy_all
      end
    end
    render json: Tag.where({utterance_id: utt_id}).pluck(:tag_type_id)
  end

  # Ajax endpoint for in-place editing of utterances
  def update
    utterance = Utterance.find_by(id: params[:id])
    if (utterance && utterance.update(utterance_params))
      head :no_content
    else
      render json: utterance&.errors, status: :unproccessable_entity
    end
  end

  private
  
  def utterance_params
    params.require(:utterance).permit(:text)
  end

end

