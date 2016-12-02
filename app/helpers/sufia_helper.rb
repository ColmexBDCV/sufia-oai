module SufiaHelper
  include ::BlacklightHelper
  include Sufia::BlacklightOverride
  include Sufia::SufiaHelperBehavior

  def search_action_for_dashboard
    case params[:controller]
    when "my/units"
      sufia.dashboard_units_path
    else
      super
    end
  end
end
