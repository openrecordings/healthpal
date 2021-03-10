class AddTimeRangesToClicks < ActiveRecord::Migration[6.0]
  def change
    add_column :clicks, :ranges_played_since_load, :json
  end
end
