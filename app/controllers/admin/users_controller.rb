class Admin::UsersController < Admin::BaseController
  def index
    @users = User.order(:username)
  end

  def show
    @user = User.find(params[:id])
  end

  def disable
    user = User.find(params[:id])
    user.update!(disabled_at: Time.current)
    redirect_to admin_users_path
  end

  def enable
    user = User.find(params[:id])
    user.update!(disabled_at: nil)
    redirect_to admin_users_path
  end

  def make_admin
    user = User.find(params[:id])
    user.update!(admin: true)
    redirect_to admin_users_path
  end

  def remove_admin
    user = User.find(params[:id])
    user.update!(admin: false)
    redirect_to admin_users_path
  end

  # v1: set a temporary password and show it once.
  # Better later: email-based reset flow.
  def reset_password
    @user = User.find(params[:id])
    @temp_password = SecureRandom.base64(12)
    @user.update!(password: @temp_password, password_confirmation: @temp_password)

    render :show
  end
end
