class OaiController < CatalogController
  def search_builder_class
    OaiSearchBuilder
  end
end
