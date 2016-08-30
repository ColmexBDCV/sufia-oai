module CurationConcerns
  class GenericWorksController < ApplicationController
    include CurationConcerns::CurationConcernController
    include Sufia::WorksControllerBehavior

    self.curation_concern_type = GenericWork

    def new
      @units = Unit.where(key: current_user.groups)
      super
    end

    # TODO - This is pretty hacky
    def create
      if attributes_for_actor['unit'].present? && current_user && ! current_user.admin?
        raise ActionController::BadRequest unless current_user.groups.include? attributes_for_actor['unit']
      end
      super
    end
  end
end
