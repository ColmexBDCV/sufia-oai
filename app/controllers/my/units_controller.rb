module My
  class UnitsController < MyController
    def search_builder_class
      ::MyUnitsSearchBuilder
    end

    def index
      super
      @selected_tab = 'units'
    end

    protected

    def search_action_url(*args)
      sufia.dashboard_units_url(*args)
    end
  end
end
