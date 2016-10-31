class UsersController < ApplicationController
  include Sufia::UsersControllerBehavior

  protected

  def user_params
    permitted_params = [:avatar, :facebook_handle, :twitter_handle,
                        :googleplus_handle, :linkedin_handle, :remove_avatar,
                        :orcid]

    # Only admins can make a user an admin
    permitted_params.concat([:admin]) if current_user.admin?

    params.require(:user).permit(permitted_params)
  end
end
