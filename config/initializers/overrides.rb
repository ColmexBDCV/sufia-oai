Rails.application.config.to_prepare do
  CurationConcerns::PermissionBadge.include Overrides::CurationConcerns::PermissionBadgeText
  CurationConcerns::FileSetPresenter.include Overrides::CurationConcerns::LinkNameText

  BatchUploadItem.include Overrides::Sufia::BatchUploadMetadata
  Sufia::FileSetPresenter.include Overrides::Sufia::CharacterizationTerms
  Sufia::CatalogSearchBuilder.include Overrides::Sufia::AdminPolicyControls
  Sufia::SufiaHelperBehavior.include Overrides::Sufia::SufiaHelperBehavior

  Hydra::Works::Characterization::FitsDatastream.include Overrides::Hydra::ResolutionTerms
  Hydra::Works::Characterization::ImageSchema.include Overrides::Hydra::ResolutionProperties

  OAI::Provider::Response::RecordResponse.include Overrides::Oai::IdentifierFormat
  OAI::Provider::Response::Base.include Overrides::Oai::IdExtractor
end
