class AddUriToRecordings < ActiveRecord::Migration[5.2]
  def change
    add_column :recordings, :uri, :string
  end
end
