class ProfilesController < ApplicationController

  before_action :authorize_self_profile,   only: [:edit, :update]
  before_action :authorize_public_profile, only: [:show]

  def show
    @profile = Profile.find(params[:id])
  end

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = Profile.find(params[:id])

    if @profile.update(profile_params)
      redirect_to @profile, notice: "Profile updated."
    else
      render "edit"
    end
  end


  private

  
  def authorize_self_profile
    user = Profile.find(params[:id]).user
    msg  = "You can change only your profile"
    authorize_user!(user, :self, msg)
  end

  def authorize_public_profile
    user = Profile.find(params[:id]).user
    msg  = "#{user.first_name} only shares #{user.genderize} profile "\
           "information with friends"
    authorize_user!(user, :public, msg)
  end

  def profile_params
    params.require(:profile).permit(:picture,   :birthday,   :country,
                                    :education, :profession, :about_you,
                                    :access_to, :email_notification,
                                    :delete_picture)
  end
end
