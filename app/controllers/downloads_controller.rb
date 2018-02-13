class DownloadsController < ApplicationController
  include CurationConcerns::DownloadBehavior
  include ImageDetection

  before_action :authorize_original_download, only: :show
  skip_before_action :store_current_location

  before_action :stats, only: :show

  def stats
    work = FileSet.find(params[:id]).parent
    creator_conacyt = work.creator_conacyt   
    ConacytStat.create( work: work.id, category: 'descargas', author: creator_conacyt )     
  end

  private

  def authorize_original_download
    authorize! :update, params[asset_param_key] if image?(file)
  end
end
