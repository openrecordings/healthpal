class AddNextApptAtToRecording < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :next_appt_at, :datetime
  end
end
