class ChangeUtteranceBeginsAtToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :utterances, :begins_at, :float
  end
end
