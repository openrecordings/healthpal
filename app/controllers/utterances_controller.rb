class UtterancesController < ApplicationController

  before_action :only_admins

  # Set (or unset if val=false) the tag (:name) for the given :utterance_id
  # Returns json of the utterance's tag_type_id's
  def set_tag
    ttype = TagType.find_by({label: params[:name]})
    if ttype
      Tag.transaction do # Clear the given tag, and then add it if val is true
        Tag.where({utterance_id: params[:utterance_id], tag_type_id: ttype.id})&.destroy_all
        if params[:val]
          tag = Tag.new({utterance_id: params[:utterance_id], tag_type_id: ttype.id})
          tag.save
        end
      end
    end
    tags = Tag.where({utterance_id: params[:utterance_id]})
    render json: tags.map(&:tag_type_id)
  end
end

