class AddEndsAtToUtterances < ActiveRecord::Migration[5.0]
  def change
    add_column :utterances, :ends_at, :float
  end
end
