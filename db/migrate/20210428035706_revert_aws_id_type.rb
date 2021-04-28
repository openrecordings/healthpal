class RevertAwsIdType < ActiveRecord::Migration[6.0]
  def change
    change_column :annotations, :aws_id, :integer
  end
end
