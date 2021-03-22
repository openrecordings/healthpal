class AddUtteranceIdToLinks < ActiveRecord::Migration[6.0]
  def change
    add_column :links, :utterance_id, :integer
  end
end
