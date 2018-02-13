# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!, :redirect_unless_admin,  only: [:new, :create]
  skip_before_action :require_no_authentication
  protected

  def after_sign_up_path_for(resource)
    '/users' # Or :prefix_to_your_route
  end

  private
  def redirect_unless_admin
    unless current_user.try(:admin?)
      flash[:error] = "Solo el administrador puede registrar usuarios"
      redirect_to root_path
    end
  end

  def sign_up(resource_name, resource)
    true
  end
end
