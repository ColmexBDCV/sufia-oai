class AddKeyToImportKeyMapping < ActiveRecord::Migration
  def change
    add_column :import_field_mappings, :key, :string
  end
end
