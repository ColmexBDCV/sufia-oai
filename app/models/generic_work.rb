# Generated via
#  `rails generate curation_concerns:work GenericWork`
class GenericWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  include Sufia::WorkBehavior
  self.human_readable_type = 'Work'
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  
  property :staff_notes, predicate: ::RDF::URI.new("https://library.osu.edu/ns#StaffNotes"), multiple: true do |index|
    index.type :text
  end

  property :spatial, predicate: ::RDF::DC.spatial do |index|
    index.as :stored_searchable, :facetable
  end

  property :alternative, predicate: ::RDF::DC.alternative do |index|
    index.as :stored_searchable, :facetable
  end

  property :temporal, predicate: ::RDF::DC.temporal do |index|
    index.as :stored_searchable, :facetable
  end

  property :format, predicate: ::RDF::DC.format do |index|
    index.as :stored_searchable, :facetable
  end

  property :provenance, predicate: ::RDF::DC.provenance do |index|
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

  property :handle, predicate: ::RDF::Vocab::Identifiers.hdl do |index|
    index.as :stored_searchable, :facetable
  end

end
