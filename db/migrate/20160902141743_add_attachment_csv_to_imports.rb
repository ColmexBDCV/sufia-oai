class AddAttachmentCsvToImports < ActiveRecord::Migration
  def self.up
    change_table :imports do |t|
      t.attachment :csv
    end
  end

  def self.down
    remove_attachment :imports, :csv
  end
end
