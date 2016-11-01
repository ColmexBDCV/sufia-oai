class ImportFieldMapping < ActiveRecord::Base
  belongs_to :import
  serialize :value, Array
  KEYS = [:pid, :cid, :resource_type, :title, :creator, :contributor, :description,
          :keyword, :publisher, :date_created, :subject, :language,
          :identifier, :based_near, :related_url, :staff_notes, :spatial,
          :alternative, :temporal, :format, :work_type, :source, :materials,
          :measurements, :part_of, :bibliographic_citation, :provenance,
          :collection_identifier, :handle].freeze

  def self.initiate_mappings(import)
    KEYS.each do |key|
      ImportFieldMapping.create key: key, import: import
    end
    # create mapping for image filename separately
    ImportFieldMapping.create key: 'image_filename', import: import
  end
end
