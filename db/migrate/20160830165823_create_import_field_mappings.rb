class CreateImportFieldMappings < ActiveRecord::Migration
  def change
    create_table :import_field_mappings do |t|
      t.timestamps
    end
  end
end
