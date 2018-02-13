class FileSetIndexer < CurationConcerns::FileSetIndexer
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc[Solrizer.solr_name('byte_order')] = object&.characterization_proxy&.byte_order
      solr_doc[Solrizer.solr_name('capture_device')] = object&.characterization_proxy&.capture_device
      solr_doc[Solrizer.solr_name('color_map')] = object&.characterization_proxy&.color_map
      solr_doc[Solrizer.solr_name('color_space')] = object&.characterization_proxy&.color_space
      solr_doc[Solrizer.solr_name('compression')] = object&.characterization_proxy&.compression
      solr_doc[Solrizer.solr_name('duration')] = object&.characterization_proxy&.duration
      solr_doc[Solrizer.solr_name('filename')] = object&.characterization_proxy&.file_name
      solr_doc[Solrizer.solr_name('file_title')] = object.file_title
      solr_doc[Solrizer.solr_name('gps_timestamp')] = object&.characterization_proxy&.gps_timestamp
      solr_doc[Solrizer.solr_name('image_producer')] = object&.characterization_proxy&.image_producer
      solr_doc[Solrizer.solr_name('last_modified')] = object&.characterization_proxy&.date_modified
      solr_doc[Solrizer.solr_name('latitude')] = object&.characterization_proxy&.latitude
      solr_doc[Solrizer.solr_name('longitude')] = object&.characterization_proxy&.longitude
      solr_doc[Solrizer.solr_name('orientation')] = object&.characterization_proxy&.orientation
      solr_doc[Solrizer.solr_name('original_checksum')] = object.original_checksum
      solr_doc[Solrizer.solr_name('page_count')] = object.page_count
      solr_doc[Solrizer.solr_name('profile_name')] = object&.characterization_proxy&.profile_name
      solr_doc[Solrizer.solr_name('profile_version')] = object&.characterization_proxy&.profile_version
      solr_doc[Solrizer.solr_name('resolution_unit')] = object&.characterization_proxy&.resolution_unit
      solr_doc[Solrizer.solr_name('resolution_x')] = object&.characterization_proxy&.resolution_x
      solr_doc[Solrizer.solr_name('resolution_y')] = object&.characterization_proxy&.resolution_y
      solr_doc[Solrizer.solr_name('sample_rate')] = object&.characterization_proxy&.sample_rate
      solr_doc[Solrizer.solr_name('scanning_software')] = object&.characterization_proxy&.scanning_software
      solr_doc[Solrizer.solr_name('well_formed')] = object.well_formed
    end
  end
end
