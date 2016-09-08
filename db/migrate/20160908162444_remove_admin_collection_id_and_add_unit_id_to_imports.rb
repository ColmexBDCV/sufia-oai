class RemoveAdminCollectionIdAndAddUnitIdToImports < ActiveRecord::Migration
  def change
    remove_column :imports, :admin_collection_id
    add_reference :imports, :unit, index: true
  end
end
