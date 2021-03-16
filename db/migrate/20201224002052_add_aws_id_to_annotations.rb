class AddAwsIdToAnnotations < ActiveRecord::Migration[6.0]
  def change
    add_column :annotations, :aws_id, :integer
  end
end
