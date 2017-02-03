class Property
  FIELDS = {
    'collection_identifier' => 'collection_identifier_sim',
    'archival_unit' => 'archival_unit_sim'
  }.freeze

  class << self
    attr_accessor :search_builder, :repository

    def all
      FIELDS.keys.map { |f| new(name: f) }
    end

    def find(name)
      raise(ArgumentError, 'Invalid property') unless FIELDS.keys.include?(name)

      solr_params = { rows: 0, facet: true, 'facet.limit' => -1, 'facet.field' => FIELDS[name] }
      response = repository.search search_builder.merge(solr_params)
      new(name: name, values: values_from_facets(response.facet_fields))
    end

    private

    def values_from_facets(facets)
      values = []
      Array(facets).each do |_facet, terms|
        values.concat terms.each_slice(2).map(&:first)
      end
      values
    end
  end

  attr_accessor :name
  attr_reader :values

  def initialize(opts = {})
    self.name = opts[:name]
    self.values = opts[:values]
  end

  def values=(value)
    @values = Array(value)
  end
end
