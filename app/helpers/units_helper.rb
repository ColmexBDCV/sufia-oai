module UnitsHelper
  def unit_name_from_key(key)
    Unit.find_by_key(key).try(:name)
  end
end
