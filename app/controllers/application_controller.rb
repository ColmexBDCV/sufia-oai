class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior

  # Adds CurationConcerns behaviors to the application controller.
  include CurationConcerns::ApplicationControllerBehavior
  # Adds Sufia behaviors into the application controller
  include Sufia::Controller

  include ApplicationHelper

  include CurationConcerns::ThemedLayoutController
  layout 'sufia-one-column'

  before_action :store_current_location, unless: :devise_controller?

  #First step for allow new fields for devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied, with: :authenticate_or_deny_access

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  protected

  def disable_turbolinks
    @disable_turbolinks = true
  end

  #Allows new fields in sign_up an update an account
  def configure_permitted_parameters
   devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :paternal_surname, :maternal_surname, :phone])
   devise_parameter_sanitizer.permit(:account_update, keys: [:name, :paternal_surname, :maternal_surname, :phone])
  end

  private

  def store_current_location
    store_location_for(:user, request.url)
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(*)
    root_path
  end

  def authenticate_or_deny_access
    if user_signed_in?
      redirect_to main_app.root_path, alert: 'You are not authorized to view this resource.'
    else
      redirect_to omniauth_authorize_path(:user, login_strategy)
    end
  end
end
