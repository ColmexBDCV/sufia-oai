module Sufia
  class BatchUploadsController < ApplicationController
    include Sufia::BatchUploadsControllerBehavior
    include ::SetUnitsBehavior

    def self.form_class
      ::Sufia::BatchUploadForm
    end
  end
end
