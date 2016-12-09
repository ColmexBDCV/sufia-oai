module DashboardHelper
  include Sufia::DashboardHelperBehavior

  # Override to add units controller
  def on_my_works?
    params[:controller].match(/^my\/(works|units)/)
  end

  def current_dashboard_tab
    params[:controller].match(/^my\/(.+)/).try(:[], 1).try(:to_sym)
  end
end
