class AddAwsTranscriptionUriToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :aws_transcription_uri, :string
  end
end
