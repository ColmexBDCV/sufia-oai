class AddAttachmentImageToUnits < ActiveRecord::Migration
  def self.up
    change_table :units do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :units, :image
  end
end
