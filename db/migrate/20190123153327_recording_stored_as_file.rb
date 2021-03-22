class RecordingStoredAsFile < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :file_name, :string
    remove_column :recordings, :encrypted_audio
    remove_column :recordings, :encrypted_audio_iv
  end
end
