class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :developer

  def all
    identity = Identity.from_omniauth request.env['omniauth.auth']
    user = identity.user

    if user.persisted?
      flash.notice = "Signed in!"
      sign_in_and_redirect user
    else
      flash.notice = "We couldn't sign you in because: " + user.errors.full_messages.to_sentence
      redirect_to new_user_session_url
    end
  end

  alias shibboleth all

  def developer
    all
  end

  def failure
    redirect_to root_path
  end
end
