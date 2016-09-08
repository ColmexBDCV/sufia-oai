class AddValueToImportFieldMapping < ActiveRecord::Migration
  def change
    add_column :import_field_mappings, :value, :string
  end
end
