module UnitsHelper
  def unit_name(unit)
    if unit.is_a? Unit
      unit.name
    else
      Unit.find_by_key(unit).try(:name)
    end
  end

  def unit_catalog_path(unit)
    key = unit.is_a?(Unit) ? unit.key : unit
    main_app.search_catalog_path(f: { 'unit_sim' => [key] })
  end
end
