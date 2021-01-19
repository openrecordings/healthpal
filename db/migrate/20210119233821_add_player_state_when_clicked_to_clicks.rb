class AddPlayerStateWhenClickedToClicks < ActiveRecord::Migration[6.0]
  def change
    add_column :clicks, :player_state_when_clicked, :string
  end
end
