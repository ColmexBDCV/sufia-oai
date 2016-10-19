module CurationConcerns
  class GenericWorksController < ApplicationController
    include CurationConcerns::CurationConcernController
    include Sufia::WorksControllerBehavior
    include ::SetUnitsBehavior

    self.curation_concern_type = GenericWork

    before_action :authorize_unit, only: [:create, :update]

    private

    def authorize_unit
      unit = Unit.find_by key: attributes_for_actor['unit']
      authorize! :curate, unit if unit.present?
    end
  end
end
