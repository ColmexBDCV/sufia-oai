module Sufia
  class HomepageController < ApplicationController
    include Sufia::HomepageControllerBehavior

    def index
      super
      @units = Unit.visible.order(:name).all
      @homepage = true
    end
  end
end
