class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include Hydra::AccessControlsEnforcement
  include CurationConcerns::SearchFilters
  include Hydra::PolicyAwareAccessControlsEnforcement
  include HasLogger
end
