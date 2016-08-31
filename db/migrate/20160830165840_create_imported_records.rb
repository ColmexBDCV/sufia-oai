class CreateImportedRecords < ActiveRecord::Migration
  def change
    create_table :imported_records do |t|

      t.timestamps null: false
    end
  end
end
