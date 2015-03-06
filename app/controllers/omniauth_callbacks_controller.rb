class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    is_new_user = User.unused_email?(request.env["omniauth.auth"].info.email)
    @user       = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      signup_welcome(@user) if is_new_user
      sign_in_and_redirect @user
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end