module Osul
  module Import
    class Item < ActiveRecord::Base
      # serialize :fid, Array
      # serialize :unit, Array
      # serialize: date_uploaded, Array
      serialize :identifier, Array
      serialize :resource_type, Array
      serialize :title, Array
      serialize :creator, Array
      serialize :contributor, Array
      serialize :description, Array
      serialize :bibliographic_citation, Array
      serialize :tag, Array
      serialize :rights, Array
      serialize :provenance, Array
      serialize :publisher, Array
      serialize :date_created, Array
      serialize :subject, Array
      serialize :language, Array
      serialize :based_near, Array
      serialize :related_url, Array
      serialize :work_type, Array
      serialize :spatial, Array
      serialize :alternative, Array
      serialize :temporal, Array
      serialize :format, Array
      serialize :staff_notes, Array
      serialize :source, Array
      serialize :part_of, Array
      # serialize :preservation_level_rationale, Array
      # serialize :preservation_level, Array
      # serialize :collection_identifier, Array
      # serialize :visibility, Array
      # serialize :collection_id, Array
      # serialize :depositor, Array
      serialize :handle, Array
      # serialize :batch_id, Array
      # serialize :collection_id, Array
      # serialize :admin_policy_id, Array
      serialize :materials, Array
      serialize :measurements, Array
      serialize :filename, Array
      # serialize :image_uri, Array

      scope :imported_items, -> {joins('JOIN osul_import_imported_items ON osul_import_imported_items.fid = osul_import_items.fid')}
      scope :unimported_items, lambda {
        joins('LEFT JOIN osul_import_imported_items ON osul_import_imported_items.fid = osul_import_items.fid')
          .where('osul_import_imported_items.fid is null')
      }
    end
  end
end
