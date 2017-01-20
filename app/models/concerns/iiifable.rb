module Iiifable
  extend ActiveSupport::Concern

  # Note: To include this concern, models must implement original_file_id and
  # original_file_version methods

  # rubocop:disable Lint/HandleExceptions
  def iiif_id(*additional)
    # Temporary fallback until repository is re-indexed
    file_id = original_file_id
    file_version = original_file_version

    if file_id.blank? && id.present?
      begin
        file_set = FileSet.find(id)
        file_id = file_set.original_file_id
        file_version = file_set.original_file_version
      rescue ActiveFedora::ObjectNotFoundError, Ldp::Gone
        # Continue if file set is not found
      end
    end

    return unless file_id
    id_parts = [ActiveFedora::Noid.treeify(file_id), file_version] + additional
    id_parts.reject(&:blank?).join('-')
  end
  # rubocop:enable Lint/HandleExceptions
end
