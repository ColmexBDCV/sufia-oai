module WorkMetadata
  extend ActiveSupport::Concern

  included do
    property :staff_notes, predicate: ::RDF::URI.new("https://library.osu.edu/ns#StaffNotes"), multiple: true do |index|
      index.type :text
      index.as :stored_searchable
    end

    property :abstract, predicate: ::RDF::Vocab::DC.abstract do |index|
      index.type :text
      index.as :stored_searchable, :facetable
    end

    property :collection_name, predicate: ::RDF::URI.new("https://library.osu.edu/ns#CollectionName"), multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    # http://www.loc.gov/standards/vracore/VRA_Core4_Element_Description.pdf#page2
    property :collection_identifier, predicate: ::RDF::URI.new('http://purl.org/vra/Collection'), multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :archival_unit, predicate: ::RDF::OSUL.archivalUnit do |index|
      index.as :stored_searchable, :facetable
    end

    # Is also the part_of field, just adds stored searchable and facetable
    property :sub_collection, predicate: ::RDF::Vocab::DC.isPartOf do |index|
      index.as :stored_searchable, :facetable
    end

    property :spatial, predicate: ::RDF::Vocab::DC.spatial do |index|
      index.as :stored_searchable, :facetable
    end

    property :alternative, predicate: ::RDF::Vocab::DC.alternative do |index|
      index.as :stored_searchable, :facetable
    end

    property :temporal, predicate: ::RDF::Vocab::DC.temporal do |index|
      index.as :stored_searchable, :facetable
    end

    property :format, predicate: ::RDF::Vocab::DC.format do |index|
      index.as :stored_searchable, :facetable
    end

    property :provenance, predicate: ::RDF::Vocab::DC.provenance do |index|
      index.as :stored_searchable, :facetable
    end

    # http://www.loc.gov/standards/vracore/VRA_Core4_Element_Description.pdf#page37
    property :work_type, predicate: ::RDF::URI.new('http://purl.org/vra/Work'), multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    # ::RDF::URI.new("http://www.loc.gov/standards/premis/v2/premis-v2-3.xsd#preservationLevelValue")
    property :preservation_level, predicate: ::RDF::Vocab::PREMIS.PreservationLevel, multiple: false do |index|
      index.as :stored_searchable, :facetable
    end

    # ::RDF::URI.new("http://www.loc.gov/standards/premis/v2/premis-v2-3.xsd#preservationLevelRationale")
    property :preservation_level_rationale, predicate: ::RDF::Vocab::PREMIS.hasPreservationLevelRationale, multiple: false do |index|
      index.as :stored_searchable, :facetable
    end

    property :bibliographic_citation, predicate: ::RDF::Vocab::DC.bibliographicCitation, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :handle, predicate: ::RDF::Vocab::Identifiers.hdl do |index|
      index.as :stored_searchable, :facetable
    end

    property :audience, predicate: ::RDF::Vocab::DC.audience do |index|
      index.type :text
      index.as :stored_searchable, :facetable
    end

    property :rights_statements, predicate: ::RDF::Vocab::EDM.rights do |index|
      index.type :text
      index.as :stored_searchable, :facetable
    end

    property :orcid, predicate: ::RDF::Vocab::Identifiers.orcid, multiple: false do |index|
      index.type :text
      index.as :stored_searchable
    end

    property :cvu, predicate: ::RDF::Vocab::Identifiers.local, multiple: false do |index|
      index.type :text
      index.as :stored_searchable
    end

    property :creator_conacyt, predicate: ::RDF::Vocab::MODS.namePrincipal, multiple: false do |index|
      index.type :text
      index.as :stored_searchable
    end

    property :contributor_conacyt, predicate: ::RDF::Vocab::MODS.name, multiple: false do |index|
      index.type :text
      index.as :stored_searchable
    end

    property :contributor_cvu, predicate: ::RDF::Vocab::MODS.partName, multiple: false do |index|
      index.type :text
      index.as :stored_searchable
    end

    property :contributor_orcid, predicate: ::RDF::Vocab::MADS.Variant, multiple: false do |index|
      index.type :text
      index.as :stored_searchable
    end

    property :subject_conacyt, predicate: ::RDF::Vocab::MODS.subjectTopic, multiple: false do |index|
      index.type :text
      index.as :stored_searchable
    end

    property :idpersona, predicate: ::RDF::Vocab::MODS.identifier, multiple: false do |index|
      index.type :text
      index.as :stored_searchable
    end
    


  end
end
