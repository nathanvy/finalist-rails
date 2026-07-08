class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[show disable enable make_admin remove_admin set_password]

  def index
    @users = User.order(:username)
  end

  def show
  end

  def disable
    @user.update!(disabled_at: Time.current)
    redirect_to admin_users_path
  end

  def enable
    @user.update!(disabled_at: nil)
    redirect_to admin_users_path
  end

  def make_admin
    @user.update!(admin: true)
    redirect_to admin_users_path
  end

  def remove_admin
    @user.update!(admin: false)
    redirect_to admin_users_path
  end

  def set_password
    if password_params[:password].blank?
      flash.now[:alert] = "New password can't be blank."
      return render :show, status: :unprocessable_entity
    end

    if @user.update(password_params)
      redirect_to admin_user_path(@user), notice: "Password updated."
    else
      flash.now[:alert] = @user.errors.full_messages.first || "Password could not be updated."
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
