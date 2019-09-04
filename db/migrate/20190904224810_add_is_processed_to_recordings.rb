class AddIsProcessedToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :is_processed, :boolean, default: false
  end
end
