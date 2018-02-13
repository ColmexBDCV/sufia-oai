class CreateConacytStats < ActiveRecord::Migration
  def change
    create_table :conacyt_stats do |t|
      t.integer :category
      t.string :work
      t.string :author

      t.timestamps null: false
    end
  end
end
