class ChangeAnnotationJsonType < ActiveRecord::Migration[6.0]
  def change
    change_column :recordings, :annotation_json, :json, array: true, default: [], using: 'ARRAY[annotation_json]::JSON[]'
  end
end
