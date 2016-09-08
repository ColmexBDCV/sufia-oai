class AddImportToImportedRecords < ActiveRecord::Migration
  def change
    add_reference :imported_records, :import, index: true
    add_column :imported_records, :generic_file_pid, :string
    add_column :imported_records, :csv_row, :integer
    add_column :imported_records, :success, :boolean
    add_column :imported_records, :message, :text
    add_column :imported_records, :has_image, :string
    add_column :imported_records, :has_watermark, :string
    add_column :imported_records, :folder_name, :string
  end
end
