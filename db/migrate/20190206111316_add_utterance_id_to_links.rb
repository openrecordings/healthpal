class AddUtteranceIdToLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :links, :utterance_id, :integer
  end
end
