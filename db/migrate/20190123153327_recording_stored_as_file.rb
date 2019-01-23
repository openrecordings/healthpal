class RecordingStoredAsFile < ActiveRecord::Migration[5.2]
  def change
    add_column :recordings, :file_name, :string
    remove_column :recordings, :encrypted_audio
    remove_column :recordings, :encrypted_audio_iv
  end
end
