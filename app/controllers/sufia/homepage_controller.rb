module Sufia
  class HomepageController < ApplicationController
    include Sufia::HomepageControllerBehavior

    def index
      super
      @units = Unit.all
      @homepage = true
    end
  end
end
