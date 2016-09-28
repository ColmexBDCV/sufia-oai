module CurationConcerns
  class GenericWorksController < ApplicationController
    include CurationConcerns::CurationConcernController
    include Sufia::WorksControllerBehavior

    self.curation_concern_type = GenericWork

    before_action :authorize_unit, only: [:create, :update]
    before_action :set_units, only: [:new, :edit]

    def edit
      @units = Unit.where(key: current_user.groups)
      super
    end

    private

    def authorize_unit
      unit = Unit.find_by key: attributes_for_actor['unit']
      authorize! :curate, unit if unit.present?
    end

    def set_units
      @units = current_user.admin? ? Unit.all : Unit.where(key: current_user.groups)
    end
  end
end
