module Overrides
  module Sufia
    module CharacterizationTerms
      extend ActiveSupport::Concern

      included do
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
    end
  end
end
