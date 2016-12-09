class MyUnitsSearchBuilder < Sufia::SearchBuilder
  include Sufia::MySearchBuilderBehavior
  include CurationConcerns::FilterByType
  include Hydra::PolicyAwareAccessControlsEnforcement
  include HasLogger

  self.default_processor_chain += [:add_advanced_search_to_solr]

  def only_works?
    true
  end

  def discovery_permissions
    ["edit"]
  end
end
