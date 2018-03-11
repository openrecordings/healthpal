class AddProviderAndDurationToRecordings < ActiveRecord::Migration[5.0]
  def change
    add_column :recordings, :provider, :string
    add_column :recordings, :duration, :integer
  end
end
