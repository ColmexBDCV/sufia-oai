module Iiifable
  extend ActiveSupport::Concern

  # Note: To include this concern, models must implement original_file_id and
  # original_file_version methods

  def iiif_id(*additional)
    id_parts = [ActiveFedora::Noid.treeify(original_file_id), original_file_version] + additional
    id_parts.reject(&:blank?).join('-')
  end
end
