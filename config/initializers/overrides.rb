Rails.application.config.to_prepare do
  # Tweak the wording of public/private/internal
  CurationConcerns::PermissionBadge.class_eval do
    def link_title
      if open_access_with_embargo?
        'Public with Embargo'
      elsif open_access?
        I18n.translate('sufia.visibility.open')
      elsif registered?
        I18n.translate('curation_concerns.institution_name')
      else
        I18n.translate('sufia.visibility.private')
      end
    end
  end

  # Add metadata to the batch proxy item
  BatchUploadItem.class_eval do
    include WorkMetadata
    include PhysicalMediaMetadata
  end
end
