class CreateImportedRecords < ActiveRecord::Migration
  def change
    create_table :imported_records do |t|
      t.belongs_to :import, index: true
      t.string :generic_file_pid, index: true
      t.integer :csv_row

      t.boolean  :success
      t.text     :message
      t.string   :has_image
      t.string   :has_watermark
      t.string   :folder_name

      t.timestamps
    end
  end
end
