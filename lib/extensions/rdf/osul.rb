# -*- encoding: utf-8 -*-
require 'rdf'

module RDF
  class OSUL < RDF::StrictVocabulary("https://library.osu.edu/ns/")
    property :archivalUnit,
             comment: %(Archival unit related to this resource.).freeze,
             "dc:description": %(Recommended best practice is to identify the related resource by means of a string conforming to a formal identification system. ).freeze,
             "dc:issued": %(2017-01-17).freeze,
             "dc:modified": %(2017-01-17).freeze,
             label: "Archival Unit".freeze,
             "rdfs:isDefinedBy": %(osul:).freeze,
             subPropertyOf: "dc11:relation".freeze,
             range: "rdfs:Literal".freeze,
             type: "rdf:Property".freeze
  end
end
