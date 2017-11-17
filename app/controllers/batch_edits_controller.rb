class BatchEditsController < ApplicationController
  include Hydra::BatchEditBehavior
  include IiifHelper
  include Sufia::BatchEditsControllerBehavior

  before_action :disable_turbolinks, only: :edit

  def update
    batch.map { |id| update_document(ActiveFedora::Base.find(id)) }
    flash[:notice] = "Batch update complete"
    after_update
  end

  def update_document(obj)
    visibility_changed = visibility_status(obj)
    obj.attributes = work_params
    obj.date_modified = Time.current.ctime
    obj.save
    VisibilityCopyJob.perform_later(obj) if visibility_changed
    InheritPermissionsJob.perform_later(obj) if work_params.fetch(:permissions_attributes, nil)
  end

  def batch
    super.map { |id| id.split(/#/).first }
  end

  protected

  def form_class
    BatchEditForm
  end

  def work_params
    @work_params ||= build_work_params
  end

  private

  def build_work_params
    work_params = params[:generic_work] || ActionController::Parameters.new
    form_class.model_attributes(work_params)
  end

  def visibility_status(object)
    selected_visibility = work_params.fetch(:visibility, nil)
    return false unless selected_visibility
    object.visibility != selected_visibility
  end
end
