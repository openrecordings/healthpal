class AddUriToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :uri, :string
  end
end
