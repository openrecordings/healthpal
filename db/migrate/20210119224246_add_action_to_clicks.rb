class AddActionToClicks < ActiveRecord::Migration[6.0]
  def change
    add_column :clicks, :action, :string
  end
end
