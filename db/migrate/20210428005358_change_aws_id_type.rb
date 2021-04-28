class ChangeAwsIdType < ActiveRecord::Migration[6.0]
  def change
    change_column :annotations, :aws_id, :float
  end
end
