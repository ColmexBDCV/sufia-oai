class CatalogSearchBuilder < Sufia::CatalogSearchBuilder
  MULTIVALUE_FILTER_FIELDS = %w(archival_unit_sim).freeze

  self.default_processor_chain += [:multivalued_filters]

  def multivalued_filters(solr_parameters)
    solr_parameters[:fq] ||= []
    filters = {}

    solr_parameters[:fq].delete_if do |filter|
      MULTIVALUE_FILTER_FIELDS.any? do |field|
        if filter.include?("f=#{field}")
          filters[field] ||= []
          filters[field] << filter
          break true
        end
      end
    end

    filters.any? do |_field, values|
      solr_parameters[:fq] << "(#{values.join(') OR (')})"
    end

    solr_parameters[:fq]
  end
end
