class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :unit, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :level, null: false

      t.timestamps null: false
    end
    add_index :memberships, :level
  end
end
