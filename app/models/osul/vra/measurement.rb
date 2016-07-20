module Osul
  module VRA
    class Measurement < ActiveFedora::Base

      belongs_to :generic_work, predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf, class_name: "GenericWork"

      property :measurement, predicate: ::RDF::URI.new('http://purl.org/vra/value'), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end
      property :measurement_unit, predicate: ::RDF::URI.new('http://purl.org/vra/unitCode'), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end
      property :measurement_type, predicate: ::RDF::URI.new('http://purl.org/vra/QuantitativeValue#type'), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end


      def display_terms
        measurement.to_s + ' ' + measurement_unit.to_s + ' ' + measurement_type.to_s
      end

   
    end
  end
end
