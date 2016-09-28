class DownloadsController < ApplicationController
  include CurationConcerns::DownloadBehavior

  before_action :authorize_original_download, only: :show

  private

  def authorize_original_download
    authorize! :update, params[asset_param_key] if file.is_a? ActiveFedora::File
  end
end
