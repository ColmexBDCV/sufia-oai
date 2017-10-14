module CurationConcerns
  class GenericWorksController < ApplicationController
    include CurationConcerns::CurationConcernController
    include Sufia::WorksControllerBehavior
    include ::SetUnitsBehavior
    include ::Tombstoneable

    self.curation_concern_type = GenericWork

    before_action :authorize_unit, only: [:create, :update]
    before_action :disable_turbolinks, only: [:edit, :new]

    def show
      respond_to do |wants|
        wants.html { presenter && parent_presenter }
        wants.json do
          # load and authorize @curation_concern manually because it's skipped for html
          # This has to use #find instead of #load_instance_from_solr because
          # we want to return values like file_set_ids in the json
          @curation_concern = _curation_concern_type.find(params[:id]) unless curation_concern
          # authorize! :show, @curation_concern
          render :show, status: :ok
        end
        additional_response_formats(wants)
        wants.ttl do
          render text: presenter.export_as_ttl
        end
        wants.jsonld do
          render text: presenter.export_as_jsonld
        end
        wants.nt do
          render text: presenter.export_as_nt
        end
      end
    end

    private

    def authorize_unit
      unit = Unit.find_by key: attributes_for_actor['unit']
      authorize! :curate, unit if unit.present?
    end
  end
end
