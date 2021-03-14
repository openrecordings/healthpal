class AddRedcapIdToParticipants < ActiveRecord::Migration[6.0]
  def change
    add_column :participants, :redcap_id, :string
  end
end
