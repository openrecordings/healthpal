class AddSpeakersToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :speakers, :integer
  end
end
