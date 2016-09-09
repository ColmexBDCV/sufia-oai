module CurationConcerns
  class GenericWorksController < ApplicationController
    include CurationConcerns::CurationConcernController
    include Sufia::WorksControllerBehavior

    self.curation_concern_type = GenericWork

    before_action :authorize_unit, only: :create

    def new
      @units = Unit.where(key: current_user.groups)
      super
    end

    def edit
      @units = Unit.where(key: current_user.groups)
      super
    end

    private

    def authorize_unit
      unit = Unit.find_by key: attributes_for_actor['unit']
      authorize! :curate, unit if unit.present?
    end
  end
end
