class UtterancesController < ApplicationController

  before_action :only_admins

  # Set (or unset if val=false) the tag (:name) for the given :utterance_id
  # Returns json of the utterance's tag_type_id's
  def set_tag
    ttype = TagType.find_by({label: params[:name]})
    if ttype
      Tag.transaction do # Clear the given tag, and then add it if val is true
        if params[:val]
          unless Tag.where({utterance_id: params[:utterance_id], tag_type_id: ttype.id}).first
            Tag.create!({utterance_id: params[:utterance_id], tag_type_id: ttype.id})
          end
        else
          Tag.where({utterance_id: params[:utterance_id], tag_type_id: ttype.id})&.destroy_all
        end
      end
    end
    render json: Tag.where({utterance_id: params[:utterance_id]}).pluck(:tag_type_id)
  end
end

