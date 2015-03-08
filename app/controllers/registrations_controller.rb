class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def create
    super
    signup_welcome(@user) if @user.errors.empty? && @user.persisted?
  end

  def unused_email
    render json: User.unused_email?(params[:user][:email])
  end


  protected


  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:first_name,
                                                  :last_name, :gender)
  end  

  def after_sign_up_path_for(user)
    newsfeed_path(user)
  end

  def after_update_path_for(user)
    newsfeed_path(user)
  end
end
