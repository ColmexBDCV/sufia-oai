class DownloadsController < ApplicationController
  include CurationConcerns::DownloadBehavior

  before_action :authorize_original_download, only: :show

  private

  def authorize_original_download
    if file.is_a?(ActiveFedora::File) && file.respond_to?(:mime_type)
      # Add MIME type detection to file if necessary
      unless file.respond_to? :image?
        file.extend(Hydra::Works::MimeTypes)
        file.class.extend(Hydra::Works::MimeTypes::ClassMethods)
      end

      authorize! :update, params[asset_param_key] if file.image?
    end
  end
end
