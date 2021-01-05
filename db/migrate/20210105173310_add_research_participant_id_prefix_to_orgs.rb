class AddResearchParticipantIdPrefixToOrgs < ActiveRecord::Migration[6.0]
  def change
    add_column :orgs, :research_participant_id_prefix, :string
  end
end
