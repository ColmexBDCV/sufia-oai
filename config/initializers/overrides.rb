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

  # Expand list of characterization terms to display
  Sufia::FileSetPresenter.class_eval do
    def self.characterization_terms
      [
        :byte_order, :compression, :height, :width, :height, :color_space,
        :profile_name, :profile_version, :orientation, :color_map,
        :image_producer, :capture_device, :scanning_software, :gps_timestamp,
        :latitude, :longitude, :file_format, :file_title, :page_count,
        :duration, :sample_rate, :file_size, :filename, :well_formed,
        :last_modified, :original_checksum, :mime_type
      ]
    end

    delegate(*characterization_terms, to: :solr_document)
  end
end
