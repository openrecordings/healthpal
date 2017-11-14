class UtterancesController < ApplicationController

  before_action :only_admins

  # Set (or unset if val=false) the tag (:name) for the given :utterance_id
  # Returns json of the utterance's tag_type_id's
  def set_tag
    ttype = TagType.find_by({label: params[:name]})
    utt_id = params[:utterance_id]
    if (!Utterance.find_by(id: utt_id))
      render html: 'This utterance is missing from the database.  Contact an administrator if the problem persists.'
    end
    
    if ttype
      if params[:val]
        unless Tag.where({utterance_id: utt_id, tag_type: ttype}).first
          Tag.create!({utterance_id: utt_id, tag_type: ttype})
        end
      else
        Tag.where({utterance_id: utt_id, tag_type: ttype})&.destroy_all
      end
    end
    render json: Tag.where({utterance_id: utt_id}).pluck(:tag_type_id)
  end
end

