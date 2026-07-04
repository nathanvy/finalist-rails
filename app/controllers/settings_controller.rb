class SettingsController < ApplicationController
  before_action :require_login!

  def show
  end

  def update
    unless current_user.authenticate(password_params[:current_password].to_s)
      flash.now[:alert] = "Current password is incorrect."
      return render :show, status: :unprocessable_entity
    end

    if password_params[:password].blank?
      flash.now[:alert] = "New password can't be blank."
      return render :show, status: :unprocessable_entity
    end

    if current_user.update(
      password: password_params[:password],
      password_confirmation: password_params[:password_confirmation]
    )
      redirect_to settings_path, notice: "Password updated."
    else
      flash.now[:alert] = current_user.errors.full_messages.first || "Password could not be updated."
      render :show, status: :unprocessable_entity
    end
  end

  private

  def password_params
    @password_params ||= params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
