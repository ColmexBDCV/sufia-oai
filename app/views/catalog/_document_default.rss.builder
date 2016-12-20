xml.item do
  xml.title(index_presenter(document).label(document_show_link_field(document)) || (document.to_semantic_values[:title].first if document.to_semantic_values.key?(:title)))
  xml.link(polymorphic_url(document))
  xml.guid(polymorphic_url(document))
  xml.description document.to_semantic_values[:description].first if document.to_semantic_values.key? :description
  xml.pubDate document.timestamp.to_s(:rfc822)
  xml.source t('blacklight.search.title', application_name: application_name), url: search_catalog_url(format: :rss)
  document.keyword.each { |k| xml.category k }

  document.to_semantic_values.except(:title, :description).each_key do |term|
    document.to_semantic_values[term].each do |value|
      xml.dc term, value
    end
  end

  # TODO: This hits Fedora and needs to be refactored to use Solr
  if document.representative_id.present?
    begin
      representative = SolrDocument.new(ActiveFedora::Base.search_by_id(document.representative_id))
      if representative.image?
        xml.media :content, url: iiif_derivative_url(representative), type: 'image/jpeg', medium: 'image'
      end
    rescue
      # Do not add a media element if errors occur
    end
  end
end
