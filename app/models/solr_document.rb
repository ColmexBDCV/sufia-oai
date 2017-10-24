# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument
  include MetadataIndexTerms
  include CharacterizationIndexTerms
  include Iiifable

  # Adds CurationConcerns behaviors to the SolrDocument.
  include CurationConcerns::SolrDocumentBehavior
  # Adds Sufia behaviors to the SolrDocument.
  include Sufia::SolrDocumentBehavior

  # Add OAI-PMH provider extension
  include BlacklightOaiProvider::SolrDocumentBehavior

  # self.unique_key = 'id'

  field_semantics.merge!(contributor: Solrizer.solr_name('contributor'),
                         coverage:    Solrizer.solr_name('spatial'),
                         creator:     Solrizer.solr_name('creator'),
                         date:        Solrizer.solr_name('date_created'),
                         description: Solrizer.solr_name('description'),
                         format:      Solrizer.solr_name('format'),
                         identifier:  'oai_identifier',
                         language:    Solrizer.solr_name('language'),
                         creator_colmex:    Solrizer.solr_name('creator_colmex'),
                         orcid:    Solrizer.solr_name('orcid'),
                         cvu:    Solrizer.solr_name('cvu'),
                         publisher:   Solrizer.solr_name('publisher'),
                         rights:      Solrizer.solr_name('rights'),
                         source:      Solrizer.solr_name('source'),
                         subject:     Solrizer.solr_name('subject'),
                         title:       Solrizer.solr_name('title'),
                         type:        Solrizer.solr_name('resource_type'),
                         access: Solrizer.solr_name('access'))

  # Override image mime types to include 'application/octet-stream'
  def self.image_mime_types
    ['image/png', 'image/jpeg', 'image/jpg', 'image/jp2', 'image/bmp', 'image/gif', 'image/tiff', "application/octet-stream"]
  end

  def self.create_access(object)
    byebug
  end

  # Email uses the semantic field mappings below to generate the body of an email.
  use_extension Blacklight::Document::Email

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  use_extension Blacklight::Document::Sms

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension Blacklight::Document::DublinCore

  # Do content negotiation for AF models.
  use_extension Hydra::ContentNegotiation

  def timestamp
    Time.parse(fetch('system_modified_dtsi', Time.at(0).utc.to_s)).utc
  end

  def sets
    OaiSet.new(Unit.spec_from_key(unit.first)) if unit
  end

  # Override SolrDocument hash access for certain virtual fields
  def [](key)
    return send(key) if ['oai_identifier'].include?(key)
    super
  end

  def oai_identifier
    [*identifier] + [*handle].map { |handle| "http://hdl.handle.net/#{handle}" }
  end

  delegate :under_copyright?, to: :to_model

  def original_file_id
    self[:original_file_id_ss]
  end

  def original_file_version
    self[:original_file_version_ss]
  end
end
