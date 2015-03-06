class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action -> { flash.now[:notice] = flash[:notice].html_safe if flash[:html_safe] && flash[:notice] }

  include ApplicationHelper


  def after_sign_in_path_for(user)
    newsfeed_path(user)
  end

  def after_sign_out_path_for(user)
    new_user_session_path
  end

  def signup_welcome(user)
    configure_signup_flash(user)
    UserMailer.welcome_email(user).deliver
  end


  private
  

  def configure_signup_flash user
    msg = "Welcome to Odinbook! You have signed up successfully."
    msg += "#{view_context.link_to('Fill your profile and configure'\
           ' your account here', edit_profile_path(user.profile))}"
    flash[:notice]    = msg
    flash[:html_safe] = true
  end
end
