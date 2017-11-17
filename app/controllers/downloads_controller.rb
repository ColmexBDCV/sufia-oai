class DownloadsController < ApplicationController
  include CurationConcerns::DownloadBehavior
  include ImageDetection

  before_action :authorize_original_download, only: :show
  skip_before_action :store_current_location

  private

  def authorize_original_download
    authorize! :update, params[asset_param_key] if image?(file)
  end
end
