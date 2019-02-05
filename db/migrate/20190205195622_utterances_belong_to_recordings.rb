class UtterancesBelongToRecordings < ActiveRecord::Migration[5.2]
  def change
    add_column :utterances, :recording_id, :integer
  end
end
