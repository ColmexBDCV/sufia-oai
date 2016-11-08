class IiifGatekeeperController < ApplicationController
  include ImageDetection

  load_and_authorize_resource :file_set, parent: false

  def show
    if image?(@file_set)
      render json: { use_identifier: iiif_identifier }
    else
      head :not_found
    end
  end

  private

  def iiif_identifier
    lowres = can?(:update, @file_set) ? nil : '-lowres'
    "#{@file_set.loris_id}#{lowres}"
  end
end
