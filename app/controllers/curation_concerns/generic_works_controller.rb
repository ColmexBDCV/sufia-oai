module CurationConcerns
  class GenericWorksController < ApplicationController
    include CurationConcerns::CurationConcernController
    include Sufia::WorksControllerBehavior

    self.curation_concern_type = GenericWork
  end
end
