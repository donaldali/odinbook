class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(user)
    newsfeed_path(user)
  end

  def after_sign_out_path_for(user)
    new_user_session_path
  end
end
