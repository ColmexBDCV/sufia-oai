module CurationConcerns
  class GenericWorksController < ApplicationController
    include CurationConcerns::CurationConcernController
    include Sufia::WorksControllerBehavior
    include ::SetUnitsBehavior
    include ::Tombstoneable

    self.curation_concern_type = GenericWork

    before_action :authorize_unit, only: [:create, :update]
    before_action :disable_turbolinks, only: [:edit, :new]

    before_action :stats, only: :show

    def stats
      creator_conacyt = GenericWork.find(params[:id]).creator_conacyt
      ConacytStat.create( work: params[:id], category: 'articulos', author: creator_conacyt )     
    end

    private

    def authorize_unit
      unit = Unit.find_by key: attributes_for_actor['unit']
      authorize! :curate, unit if unit.present?
    end
  end
end
