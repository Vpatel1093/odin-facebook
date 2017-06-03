class ProfileController < ApplicationController
  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile

    if @profile.update_attributes(profile_params)
      redirect_to current_user, notice: "Profile updated!"
    else
      flash.now[:danger] = "Error updating profile."
      render 'profile#edit'
    end
  end

  private

    def profile_params
      params.require(:profile).permit(:first_name, :last_name)
    end
end
