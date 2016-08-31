class CreateImportFieldMappings < ActiveRecord::Migration
  def change
    create_table :import_field_mappings do |t|

      t.timestamps null: false
    end
  end
end
