class IiifGatekeeperController < ApplicationController
  include ImageDetection

  before_filter :load_file_set
  authorize_resource :file_set, parent: false

  def show
    if image?(@file_set)
      authorize! :update, @file_set unless ident_lowres?
      render json: { status: 'approved' }
    else
      head :not_found
    end
  end

  private

  def load_file_set
    @file_set = FileSet.find(identifiers[:file_set_id])
  end

  def identifiers
    @identifiers || FileSet.decode_loris_id(params[:ident], 'lowres')
  end

  def ident_lowres?
    params[:ident].include? '-lowres'
  end
end
