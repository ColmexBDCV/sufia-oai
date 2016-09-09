class CreateImportFieldMappings < ActiveRecord::Migration
  def change
    create_table :import_field_mappings, &:timestamps
  end
end
