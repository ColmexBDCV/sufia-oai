class CreateImportedRecords < ActiveRecord::Migration
  def change
    create_table :imported_records, &:timestamps
  end
end
