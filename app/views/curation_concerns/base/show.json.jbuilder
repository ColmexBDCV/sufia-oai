json.extract! @curation_concern, *[:id] + @curation_concern.class.fields.select {|f| ![:has_model].include? f}
json.thumbnail @curation_concern.thumbnail
json.file_set_ids @curation_concern.file_set_ids
