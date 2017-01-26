module API
  module ControllerBehavior
    extend ActiveSupport::Concern

    included do
      respond_to :json, :xml
    end
  end
end
