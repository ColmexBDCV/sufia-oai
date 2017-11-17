xml.instruct! :xml, version: "1.0"
xml.rss(version: "2.0",
        "xmlns:atom" => "http://www.w3.org/2005/Atom",
        "xmlns:dc" => "http://purl.org/dc/terms/",
        "xmlns:media" => "http://search.yahoo.com/mrss/",
        "xmlns:iiif" => "http://iiif.io/api/image/2.0/") do
  xml.channel do
    xml.title(t('blacklight.search.title', application_name: application_name))
    xml.link(root_url)
    xml.description(t('blacklight.search.title', application_name: application_name))
    xml.language('en-us')
    xml.dc :publisher, "The Ohio State University"
    xml.copyright "Copyright #{Time.now.year}, The Ohio State University"
    xml.atom :link, href: search_action_url(params.to_unsafe_h), rel: "self", type: "application/rss+xml"
    @document_list.each_with_index do |document, document_counter|
      xml << Nokogiri::XML.fragment(render_document_partials(document, blacklight_config.view_config(:rss).partials, document_counter: document_counter))
    end
  end
end
