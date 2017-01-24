class CatalogSearchBuilder < Sufia::CatalogSearchBuilder
  MULTIVALUE_FILTER_FIELDS = %w(archival_unit_sim).freeze

  self.default_processor_chain += [:multivalued_filters]

  def multivalued_filters(solr_parameters)
    solr_parameters[:fq] ||= []
    filters = {}
    tags = {}

    solr_parameters[:fq].delete_if do |filter|
      MULTIVALUE_FILTER_FIELDS.any? do |field|
        if filter.include?("f=#{field}")
          filter_parts = filter.match(/(\{!.*?(?:tag=(\w+))?\})?(.+)?/)
          break unless filter_parts.try(:[], 1)

          filters[field] ||= []
          filters[field] << filter_parts[3]
          tags[field] = "{!tag=#{filter_parts[2]}}" if filter_parts[2]
          break true
        end
      end
    end

    filters.any? do |field, values|
      values.map! { |v| "#{tags[field]}#{field}:\"#{v}\"" }
      solr_parameters[:fq] << values.join(' ')
    end

    solr_parameters[:fq]
  end
end
