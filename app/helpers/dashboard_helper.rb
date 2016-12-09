module DashboardHelper
  include Sufia::DashboardHelperBehavior

  # Override to add units controller
  def on_my_works?
    params[:controller].match(/^my\/(works|units)/)
  end
end
