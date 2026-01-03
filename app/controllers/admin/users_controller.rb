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

  def set_password
    user = User.find(params[:id])
    new_password = params[:new_password].to_s

    user.update!(password: new_password, password_confirmation: new_password)
    redirect_to admin_user_path(user), notice: "Password updated."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to admin_user_path(user), alert: e.record.errors.full_messages.first
  end
end
