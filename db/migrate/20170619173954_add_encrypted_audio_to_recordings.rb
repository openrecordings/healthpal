class AddEncryptedAudioToRecordings < ActiveRecord::Migration[5.0]
  def change
    remove_column :recordings, :audio
    add_column :recordings, :encrypted_audio, :binary
    add_column :recordings, :encrypted_audio_iv, :binary
  end
end
