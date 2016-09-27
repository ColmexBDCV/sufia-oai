class RemoveAdminCollectionIdAndAddUnitIdToImports < ActiveRecord::Migration
  def change
    remove_column :imports, :admin_collection_id
    add_reference :imports, :unit, index: true
    add_column    :imports, :collection_id, :string
  end
end
