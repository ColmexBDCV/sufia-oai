# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds CurationConcerns behaviors to the SolrDocument.
  include CurationConcerns::SolrDocumentBehavior
  # Adds Sufia behaviors to the SolrDocument.
  include Sufia::SolrDocumentBehavior

  # self.unique_key = 'id'

  # Override image mime types to include 'application/octet-stream'
  def self.image_mime_types
    ['image/png', 'image/jpeg', 'image/jpg', 'image/jp2', 'image/bmp', 'image/gif', 'image/tiff', "application/octet-stream"]
  end

  def unit
    self[Solrizer.solr_name('unit')]
  end

  def alternative
    self[Solrizer.solr_name('alternative')]
  end

  def format
    self[Solrizer.solr_name('format')]
  end

  def bibliographic_citation
    self[Solrizer.solr_name('bibliographic_citation')]
  end

  def handle
    self[Solrizer.solr_name('handle')]
  end

  def preservation_level
    self[Solrizer.solr_name('preservation_level')]
  end

  def preservation_level_rationale
    self[Solrizer.solr_name('preservation_level_rationale')]
  end

  def provenance
    self[Solrizer.solr_name('provenance')]
  end

  def spatial
    self[Solrizer.solr_name('spatial')]
  end

  def staff_notes
    self[Solrizer.solr_name('staff_notes')]
  end

  def temporal
    self[Solrizer.solr_name('temporal')]
  end

  def work_type
    self[Solrizer.solr_name('work_type')]
  end

  def material
    self[Solrizer.solr_name('material')]
  end

  def material_type
    self[Solrizer.solr_name('material_type')]
  end

  def measurement
    self[Solrizer.solr_name('measurement')]
  end

  def measurement_unit
    self[Solrizer.solr_name('measurement_unit')]
  end

  def measurement_type
    self[Solrizer.solr_name('measurement_type')]
  end

  def sub_collection
    self[Solrizer.solr_name('sub_collection')]
  end

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.
  use_extension( Hydra::ContentNegotiation )
end
