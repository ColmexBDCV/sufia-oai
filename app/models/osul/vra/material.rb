module Osul
  module VRA
    class Material < ActiveFedora::Base
      belongs_to :generic_work, predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf, class_name: "GenericWork"

      property :material, predicate: ::RDF::URI.new('http://purl.org/vra/material'), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      property :material_type, predicate: ::RDF::URI.new('http://purl.org/vra/Material#type'), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end

      def display_terms
        material + (material_type.present? ? ' - ' + material_type : "")
      end
    end
  end
end
