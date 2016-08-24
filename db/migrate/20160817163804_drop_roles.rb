class DropRoles < ActiveRecord::Migration
  def up
    drop_table :roles_users
    drop_table :roles
  end

  def down
    create_table :roles do |t|
      t.string :name
    end
    create_table :roles_users, id: false do |t|
      t.references :role
      t.references :user
    end
    add_index :roles_users, [:role_id, :user_id]
    add_index :roles_users, [:user_id, :role_id]
  end
end
