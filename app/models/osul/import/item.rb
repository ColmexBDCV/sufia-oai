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

      # Make sure item matches what is in old IMS
      def verify_item
        require "net/http"
        Osul::Import::Item.all.each_with_index do |obj, i|
          Rails.logger.debug i
          Rails.logger.debug obj.fid
          next if i < 4916
          url = "https://library.osu.edu/ims/osul/export/export_generic_file_items/#{obj.fid}.json"
          uri = URI(url)

          req = Net::HTTP::Get.new(uri)

          response = Net::HTTP.start(
            uri.host, uri.port,
            use_ssl: uri.scheme == 'https',
            verify_mode: OpenSSL::SSL::VERIFY_NONE
          ) do |https|
            https.request(req)
          end

          item = JSON.parse(response.body, object_class: OpenStruct)
          result, different = compare_item_values(item)
          next if result
          # print to csv
          CSV.open("comparison_check", "a") do |csv|
            csv << [item.id] + different
          end
        end
      end

      # check if item in purple matches item in ims
      def compare_item_values(item)
        different = []
        result = true
        begin
          gw = GenericWork.find item.id
        rescue
          return false, ["error on gw lookup"]
        end
        terms.each do |t|
          result, different = same_attribute?(gw, item, different, t)
        end
        unless item.tag == gw.keyword
          different << "tag-keyword"
          result = false
        end

        col = collection_lookup(item.collection_id)
        unless col == gw.collection_name.first
          different << "collection_name"
          result = false
        end

        fs = gw.file_sets.first
        return false, ["error on fileset lookup"] if fs.blank?

        unless item.label == fs.label
          Rails.logger.debug "label"
          different << "label"
          result = false
        end
        [result, different]
      end

      def collection_lookup(old_collection_id)
        h = { "3db58b0e-a963-4f67-878d-95a18b1f5216" => "Sir George Hubert Wilkins Papers",
              "d8858659-c4bd-4936-a7f8-3d956c4f33c5" => "Frederick A. Cook Society Collection",
              "2df457d8-f0d6-45ab-a857-3e3769ee8aa3" => "Admiral Richard E. Byrd Papers",
              "5994a903-98d0-41ab-9575-f8e34b4023cf" => "Collin Bull Papers",
              "70acb5d0-41ff-4481-8c3f-c6c33aed4d18" => "Lois M. Jones Papers" }
        h[old_collection_id]
      end

      def same_attribute?(gw, item, different, t)
        if gw.send(t).class == ActiveTriples::Relation
          unless gw.send(t) - item.send(t) == [] # comparing arrays where content may not be in same order
            Rails.logger.debug t
            different << t
            return false, different
          end
        else
          unless gw.send(t) == item.send(t)
            different << t
            result = false
          end
        end
        [result, different]
      end

      def terms
        # removed visibility b/c it's coming from solr :visibility
        [ :date_uploaded, :identifier, :abstract, :resource_type, :title, :creator_colmex, :creator, :orcid, :cvu, :contributor, :description, :bibliographic_citation,
          :rights, :provenance, :publisher, :date_created, :subject, :language, :based_near, :related_url,
          :work_type, :spatial, :alternative, :temporal, :format, :staff_notes, :source, :part_of, :preservation_level_rationale,
          :preservation_level, :depositor, :handle, :id, :visibility, :unit, :collection_identifier]
      end

      def complex_terms
        [:materials, :measurements]
      end
    end
  end
end
