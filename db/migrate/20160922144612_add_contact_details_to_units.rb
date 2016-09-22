class AddContactDetailsToUnits < ActiveRecord::Migration
  def change
    add_column :units, :contact_person, :string
    add_column :units, :address, :string
    add_column :units, :phone, :string
    add_column :units, :fax, :string
    add_column :units, :email, :string
    add_column :units, :url, :string

    remove_column :units, :contact_info, :text
  end
end
