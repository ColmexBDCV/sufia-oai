# Overriding Blacklight so that the search results can be displayed in a way compatible with
# tokenInput javascript library.  This is used for suggesting "Related Works" to attach.

json.docs @presenter.documents do |solr_document|
  title = solr_document['title_tesim'].first
  # title << " (#{solr_document['human_readable_type_tesim'].first})" if solr_document['human_readable_type_tesim'].present?
  json.pid solr_document['id']
  json.title title
  sl = []
  solr_document['object_profile_ssm'].each do |d|
    sl.push(JSON.parse(d))
  end
  json.solr_document sl

end
json.facets @presenter.search_facets_as_json
json.pages @presenter.pagination_info
