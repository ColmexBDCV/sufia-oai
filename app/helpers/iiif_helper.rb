module IiifHelper
  def loris_url_for(file_set_id)
    file_set = FileSet.find(file_set_id)
    lowres = cannot?(:update, file_set) && file_set.under_copyright? ? 'lowres' : nil
    Rails.configuration.x.iiif.base_url + file_set.loris_id(lowres)
  end
end
