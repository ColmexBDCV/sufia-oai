class DownloadsController < ApplicationController
  include CurationConcerns::DownloadBehavior

  before_action :authorize_original_download, only: :show

  # module ClassMethods
  #   def default_content_path
  #     :original_file
  #   end
  # end

  private

  def authorize_original_download
    authorize! :update, params[asset_param_key] if file.is_a? ActiveFedora::File
  end
end
