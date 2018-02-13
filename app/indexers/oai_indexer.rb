class OAIIndexer < Sufia::WorkIndexer
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc[Solrizer.solr_name("access", :stored_searchable)] = object.visibility
    end
  end
end
