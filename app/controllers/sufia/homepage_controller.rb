module Sufia
  class HomepageController < ApplicationController
    include Sufia::HomepageControllerBehavior

    def index
      super
      @units = Unit.where(visible: true).order(:name).all
      @homepage = true
    end
  end
end
