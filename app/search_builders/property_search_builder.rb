class PropertySearchBuilder < Sufia::CatalogSearchBuilder
  self.default_processor_chain += [:includes_filter, :facet_query_params]

  def includes_filter(solr_parameters)
    if blacklight_params[:includes]
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << blacklight_params[:includes]
    end
  end

  def facet_query_params(solr_parameters)
    solr_parameters.merge(rows: 0, facet: true, 'facet.limit' => -1)
  end
end
