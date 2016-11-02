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
        :byte_order, :compression, :width, :height, :resolution_x,
        :resolution_y, :resolution_unit, :color_space, :profile_name,
        :profile_version, :orientation, :color_map, :image_producer,
        :capture_device, :scanning_software, :gps_timestamp, :latitude,
        :longitude, :file_format, :file_title, :page_count, :duration,
        :sample_rate, :file_size, :filename, :well_formed, :last_modified,
        :original_checksum, :mime_type
      ]
    end

    delegate(*characterization_terms, to: :solr_document)
  end

  # Add resolution information to characterization
  Hydra::Works::Characterization::FitsDatastream.class_eval do
    extend_terminology do |t|
      terms = {
        resolution_x: 'xSamplingFrequency',
        resolution_y: 'ySamplingFrequency',
        resolution_unit: 'samplingFrequencyUnit'
      }

      terms.each do |term, path|
        builder = OM::XML::Term::Builder.new(term.to_s, t)
        t.term_builders[:metadata].retrieve_child(:image).add_child(builder)
        builder.settings[:path] = path

        t.send(term, proxy: [:metadata, :image, term])
      end
    end
  end

  Hydra::Works::Characterization::ImageSchema.class_eval do
    property :resolution_unit, predicate: RDF::Vocab::EXIF.resolutionUnit
    property :resolution_x, predicate: RDF::Vocab::EXIF.xResolution
    property :resolution_y, predicate: RDF::Vocab::EXIF.yResolution
  end
end
