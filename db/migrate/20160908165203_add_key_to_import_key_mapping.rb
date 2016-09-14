class AddKeyToImportKeyMapping < ActiveRecord::Migration
  def change
    add_column    :import_field_mappings, :key, :string
    add_reference :import_field_mappings, :import, index: true
    add_column    :import_field_mappings, :value, :string
  end
end
