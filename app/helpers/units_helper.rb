module UnitsHelper
  def unit_name_from_key(key)
    Unit.find_by_key(key).try(:name)
  end

  def unit_catalog_path(unit)
    search_catalog_path(f: { 'unit_sim' => [unit.key] })
  end
end
