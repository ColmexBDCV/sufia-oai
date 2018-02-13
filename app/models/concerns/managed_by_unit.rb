module ManagedByUnit
  extend ActiveSupport::Concern

  included do
    belongs_to :admin_policy, predicate: ActiveFedora::RDF::ProjectHydra.isGovernedBy

    before_save :set_admin_policy

    property :unit, predicate: ::RDF::URI.new('https://library.osu.edu/ns#unit'), multiple: false do |index|
      index.as :stored_searchable, :facetable, :symbol
    end
  end

  def responsible_unit
    Unit.find_by_key(unit)
  end

  private

  def set_admin_policy
    self.admin_policy = responsible_unit.admin_policy if unit.present?
  end
end
