class DownloadsController < ApplicationController
  include CurationConcerns::DownloadBehavior

  module ClassMethods
    def default_content_path
      :original_file
    end
  end

  def show
    case file
    when ActiveFedora::File
      authorize! :download_original, params[asset_param_key]
      super
    when String
      # For derivatives stored on the local file system
      response.headers['Accept-Ranges'] = 'bytes'
      response.headers['Content-Length'] = File.size(file).to_s
      send_file file, derivative_download_options
    else
      render_404
    end
  end
end
