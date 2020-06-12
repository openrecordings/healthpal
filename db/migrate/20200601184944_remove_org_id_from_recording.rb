class RemoveOrgIdFromRecording < ActiveRecord::Migration[6.0]
  def change
    remove_column :recordings, :org_id
  end
end
