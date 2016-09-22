class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name, null: false
      t.text :description
      t.text :contact_info
      t.string :key, null: false

      t.timestamps null: false
    end
    add_index :units, :key
  end
end
