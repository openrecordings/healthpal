class UtterancesBelongToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :utterances, :recording_id, :integer
  end
end
