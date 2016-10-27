class UsersController < ApplicationController
  include Sufia::UsersControllerBehavior

  protected

  def user_params
    params.require(:user).permit(:avatar, :facebook_handle, :twitter_handle,
                                 :googleplus_handle, :linkedin_handle, :remove_avatar, :orcid, :admin)
  end
end
