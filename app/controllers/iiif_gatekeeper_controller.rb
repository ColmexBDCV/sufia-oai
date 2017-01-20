class IiifGatekeeperController < ApplicationController
  include ImageDetection

  before_action :load_file_set
  authorize_resource :file_set, parent: false
  skip_before_action :store_current_location

  def show
    if image?(@file_set)
      authorize! :update, @file_set if @file_set.under_copyright? && original_ident?
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
    @identifiers || decode_iiif_id(params[:ident], 'lowres')
  end

  def original_ident?
    !params[:ident].include? '-lowres'
  end

  def decode_iiif_id(id, *additional)
    id = id.dup
    id.gsub!(/-version[0-9]+/, '')
    additional.each { |addl| id.gsub!("-#{addl}", '') }
    parts = id.split('/')
    { file_set_id: parts[4], file_id: parts[6] }
  end
end
