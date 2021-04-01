class AddMedlineSummaryAndUrlToAnnotations < ActiveRecord::Migration[6.0]
  def change
    add_column :annotations, :medline_summary, :string
    add_column :annotations, :medline_url, :string
  end
end
