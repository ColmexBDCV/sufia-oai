class AddAdminPolicyIdToUnits < ActiveRecord::Migration
  def change
    add_column :units, :admin_policy_id, :string
  end
end
