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

    def find(name, params = {})
      raise(ArgumentError, 'Invalid property') unless FIELDS.keys.include?(name)

      params[:includes] = "#{FIELDS[name]}: *#{params[:includes]}*" if params[:includes]
      response = repository.search search_builder.with(params).merge('facet.field' => FIELDS[name])
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
