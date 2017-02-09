Rails.application.config.to_prepare do
  CurationConcerns::PermissionBadge.include Overrides::CurationConcerns::PermissionBadgeText

  BatchUploadItem.include Overrides::Sufia::BatchUploadMetadata
  Sufia::FileSetPresenter.include Overrides::Sufia::CharacterizationTerms
  Sufia::CatalogSearchBuilder.include Overrides::Sufia::AdminPolicyControls

  Hydra::Works::Characterization::FitsDatastream.include Overrides::Hydra::ResolutionTerms
  Hydra::Works::Characterization::ImageSchema.include Overrides::Hydra::ResolutionProperties

  OAI::Provider::Response::RecordResponse.include Overrides::Oai::IdentifierFormat
  OAI::Provider::Response::Base.include Overrides::Oai::IdExtractor
  Sufia::SufiaHelperBehavior.include Overrides::Sufia::SufiaHelperBehavior
end
