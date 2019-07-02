class RecordingColumnChanges < ActiveRecord::Migration[6.0]
  def change
    rename_column :recordings, :uri, :gcp_uri
    rename_column :recordings, :url, :gcp_public_url
    remove_column :recordings, :video
    remove_column :recordings, :text
    remove_column :recordings, :provider
    remove_column :recordings, :filetype
    add_column :recordings, :aws_bucket_name, :string
    add_column :recordings, :aws_public_url, :string
  end
end
