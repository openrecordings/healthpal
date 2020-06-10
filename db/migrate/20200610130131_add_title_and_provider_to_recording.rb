class AddTitleAndProviderToRecording < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :title, :string
    add_column :recordings, :provider, :string
  end
end
