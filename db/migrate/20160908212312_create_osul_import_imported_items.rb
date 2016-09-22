class CreateOsulImportImportedItems < ActiveRecord::Migration
  def change
    create_table :osul_import_imported_items do |t|
      t.string :fid
      t.string :got_image
      t.string :object_type
      t.string :gw_relation
      t.text :message
      t.timestamps null: false
    end
  end
end
