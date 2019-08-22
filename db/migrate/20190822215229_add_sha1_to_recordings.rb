class AddSha1ToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :sha1, :string
  end
end
