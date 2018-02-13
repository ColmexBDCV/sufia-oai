module MetadataIndexTerms
  extend ActiveSupport::Concern

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

  def abstract
    self[Solrizer.solr_name('abstract')]
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

  def collection_name
    self[Solrizer.solr_name('collection_name')]
  end

  def sub_collection
    self[Solrizer.solr_name('sub_collection')]
  end

  def collection_identifier
    self[Solrizer.solr_name('collection_identifier')]
  end

  def archival_unit
    self[Solrizer.solr_name('archival_unit')]
  end

  def audience
    self[Solrizer.solr_name('audience')]
  end

  def rights_statements
    self[Solrizer.solr_name('rights_statements')]
  end

  def creator_conacyt
    self[Solrizer.solr_name('creator_conacyt')]
  end

  def orcid
    self[Solrizer.solr_name('orcid')]
  end

  def cvu
    self[Solrizer.solr_name('cvu')]
  end

  def curp
    self[Solrizer.solr_name('curp')]
  end

  def contributor_conacyt
    self[Solrizer.solr_name('contributor_conacyt')]
  end

  def contributor_orcid
    self[Solrizer.solr_name('contributor_orcid')]
  end

  def contributor_cvu
    self[Solrizer.solr_name('contributor_cvu')]
  end

  def access
    self[Solrizer.solr_name('access')]
  end

  def subject_conacyt
    self[Solrizer.solr_name('subject_conacyt')]
  end

  def idpersona
    self[Solrizer.solr_name('idpersona')]
  end
end
