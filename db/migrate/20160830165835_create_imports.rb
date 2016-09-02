class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :name
      t.boolean :includes_headers, default: true
      t.integer :status, default: 0
      t.belongs_to :user, index: true

      t.string :admin_collection_id
      t.string :server_import_location_name
      t.string :import_type
      t.string :rights
      t.string :preservation_level
      t.string :visibility

      t.timestamps
    end
  end
end
