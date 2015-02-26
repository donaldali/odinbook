class ProfilesController < ApplicationController
  layout "layouts/users"

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
      flash.now[:alert] = "Unable to update profile."
      render "edit"
    end
  end


  private


  def profile_params
    params.require(:profile).permit(:birthday,   :country, :education,
                                    :profession, :about_you,
                                    :access_to,  :email_notification)
  end
end
