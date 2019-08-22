class RecordingChanges < ActiveRecord::Migration[6.0]
  def change
    remove_column :recordings, :patient_identifier
    remove_column :recordings, :file_name
    remove_column :recordings, :gcp_uri
    remove_column :recordings, :original_file_name
    remove_column :recordings, :source
    remove_column :recordings, :gcp_public_url

    add_column :recordings, :media_format, :string
  end
end
