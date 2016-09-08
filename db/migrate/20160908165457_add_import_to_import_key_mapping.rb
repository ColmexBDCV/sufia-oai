class AddImportToImportKeyMapping < ActiveRecord::Migration
  def change
    add_reference :import_field_mappings, :import, index: true
  end
end
