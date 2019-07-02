class AddAwsMediaKeyToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :aws_media_key, :string
  end
end
