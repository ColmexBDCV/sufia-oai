Rails.application.config.to_prepare do
  CurationConcerns::PermissionBadge.include Overrides::CurationConcerns::PermissionBadge::BadgeText

  BatchUploadItem.include Overrides::BatchUploadItem::Metadata

  Sufia::FileSetPresenter.include Overrides::Sufia::FileSetPresenter::CharacterizationTerms

  Hydra::Works::Characterization::FitsDatastream.include Overrides::Hydra::Works::Characterization::FitsDatastream::ResolutionTerms

  Hydra::Works::Characterization::ImageSchema.include Overrides::Hydra::Works::Characterization::ImageSchema::ResolutionProperties

  Sufia::CatalogSearchBuilder.include Overrides::Sufia::SearchBuilder::AdminPolicyControls
end
