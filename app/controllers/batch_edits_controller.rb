class BatchEditsController < ApplicationController
  include Hydra::BatchEditBehavior
  include FileSetHelper
  include Sufia::BatchEditsControllerBehavior

  before_action :disable_turbolinks, only: :edit

  def form_class
    ::Sufia::BatchEditForm
  end
end
