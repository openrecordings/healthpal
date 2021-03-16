class AddTimesToAnnotations < ActiveRecord::Migration[6.0]
  def change
    add_column :annotations, :start_time, :float
    add_column :annotations, :end_time, :float
  end
end
