class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include Hydra::AccessControlsEnforcement
  include CurationConcerns::SearchFilters
  include Hydra::PolicyAwareAccessControlsEnforcement

  def logger
    Rails.logger
  end
end
